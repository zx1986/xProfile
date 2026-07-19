# Ubuntu Offline Installation Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refine the Ubuntu offline installation package by completely excluding the Antigravity CLI (`agy`), warming up all Neovim plugins/Mason LSPs synchronously, and adding target username configuration to the installer script.

**Architecture:** We will modify the Antigravity template installer to render as empty when `is_offline: true`, run `rm -rf` inside the Docker bundle build to delete `agy` and its cache directories, adjust the Neovim warmup command to fetch all 5 Mason packages and run `TSUpdateSync`, and rewrite `install_offline.sh` to parse target username, apply target user ownership, and run `chezmoi apply` via `sudo -u`.

**Tech Stack:** Chezmoi templates, Docker, Bash, Neovim

## Global Constraints

* Exclude Antigravity (`agy`) and related components completely from offline setups.
* Ensure Neovim plugins, Mason LSPs (`lua-language-server`, `stylua`, `html-lsp`, `css-lsp`, `prettier`), and Treesitter parsers are fully cached.
* Support target username input and run Chezmoi apply in target user's context.

---

### Task 1: Exclude Antigravity and Add Template Validation Tests

**Files:**
- Modify: `run_once_before_06_install_antigravity.sh.tmpl`
- Modify: `tests/suite_linux.sh`
- Modify: `tests/suite_common.sh`

- [ ] **Step 1: Wrap `run_once_before_06_install_antigravity.sh.tmpl` in `is_offline` check**

  Modify [run_once_before_06_install_antigravity.sh.tmpl](file:///home/zx1986/Projects/dotfiles/run_once_before_06_install_antigravity.sh.tmpl) to wrap the entire installer script inside `{{- if not (index . "is_offline") }}` conditional:

  ```diff
  +{{- if not (index . "is_offline") }}
   #!/bin/bash
   
   # Install antigravity-cli (agy)
  @@ -35,4 +35,5 @@
   "$HOME/.local/bin/agy" plugin install "{{ . }}" || echo "Warning: Failed to install plugin {{ . }}"
   {{- end }}
   {{- end }}
  +{{- end }}
  ```

- [ ] **Step 2: Update tests in `tests/suite_common.sh`**

  Modify [tests/suite_common.sh](file:///home/zx1986/Projects/dotfiles/tests/suite_common.sh) to remove the outdated `Understand-Anything` installation check from the common suite:

  ```diff
   # Add some checks for directories we expect to exist
   check ".tmux.conf.local exists" "[[ -f \$TMP_HOME/.tmux.conf.local ]]"
   check "antigravity installation script rendered" "[[ -f \$TMP_HOME/06_install_antigravity.sh ]]"
  -check "antigravity installation script installs Egonex-AI/Understand-Anything" "grep -q 'Understand-Anything' \$TMP_HOME/06_install_antigravity.sh"
  ```

- [ ] **Step 3: Add offline template validation test to `tests/suite_linux.sh`**

  Modify [tests/suite_linux.sh](file:///home/zx1986/Projects/dotfiles/tests/suite_linux.sh) to assert that when `is_offline` is set to `true`, the rendered `06_install_antigravity.sh` template is completely empty:

  ```diff
   check "Font installation script rendered" "grep -q 'JetBrainsMono' \$TMP_HOME/after_install_fonts.sh"
   check "Font version is correct" "grep -q 'version=\"v3.2.1\"' \$TMP_HOME/after_install_fonts.sh"
  +check "antigravity installation script is empty when offline" "[[ -z \$(chezmoi execute-template --source . --override-data-file .chezmoidata.yaml --override-data '{\"is_offline\": true, \"chezmoi\": {\"os\": \"linux\"}}' run_once_before_06_install_antigravity.sh.tmpl | tr -d '[:space:]') ]]"
  ```

- [ ] **Step 4: Run template tests to verify they pass**

  Run:
  ```bash
  make test
  ```
  Expected: PASS

- [ ] **Step 5: Commit changes**

  Run:
  ```bash
  git add run_once_before_06_install_antigravity.sh.tmpl tests/suite_common.sh tests/suite_linux.sh
  git commit -m "feat(offline): exclude antigravity installer in offline mode and add tests"
  ```

---

### Task 2: Update Dockerfile.bundle for Clean Snapshot & Neovim Hydration

**Files:**
- Modify: `docker/ubuntu/Dockerfile.bundle`

- [ ] **Step 1: Modify Neovim warmup and snapshot cleanup steps**

  Modify [docker/ubuntu/Dockerfile.bundle](file:///home/zx1986/Projects/dotfiles/docker/ubuntu/Dockerfile.bundle) to install all 5 Mason packages and run Treesitter `TSUpdateSync` synchronously, then remove any `agy` binary and config folders before snapshotting:

  ```diff
   # 4. Warm up Neovim (Lazy & Mason)
  -RUN nvim --headless "+Lazy! sync" +qa && \
  -    nvim --headless "+MasonInstall lua-language-server" +qa
  +RUN nvim --headless "+Lazy! sync" "+TSUpdateSync" "+MasonInstall lua-language-server stylua html-lsp css-lsp prettier" +qa
   
   # 5. Create final bundle structure
   USER root
  +RUN rm -rf /home/user/.local/bin/agy /home/user/.gemini
   COPY docker/ubuntu/install_offline.sh /offline/install.sh
  ```

- [ ] **Step 2: Commit changes**

  Run:
  ```bash
  git add docker/ubuntu/Dockerfile.bundle
  git commit -m "feat(offline): pre-install all mason LSPs, compile treesitter parsers, and purge agy from bundle snapshot"
  ```

---

### Task 3: Rewrite Offline Installer Script for Target Username

**Files:**
- Modify: `docker/ubuntu/install_offline.sh`

- [ ] **Step 1: Rewrite installer shell script**

  Overwrite [docker/ubuntu/install_offline.sh](file:///home/zx1986/Projects/dotfiles/docker/ubuntu/install_offline.sh) to accept `--user`, perform ownership enforcement, and run chezmoi in target user context:

  ```bash
  #!/bin/bash
  set -e
  
  echo ">>> Starting Offline Installation..."
  
  # 1. Parse arguments
  TARGET_USER=""
  while [[ "$#" -gt 0 ]]; do
      case $1 in
          -u|--user) TARGET_USER="$2"; shift ;;
          *) echo "Unknown parameter: $1"; exit 1 ;;
      esac
      shift
  done
  
  # 2. Auto-detect target user
  if [ -z "$TARGET_USER" ]; then
      if [ -n "$SUDO_USER" ]; then
          TARGET_USER="$SUDO_USER"
          echo ">>> Auto-detected target user from sudo context: $TARGET_USER"
      else
          TARGET_USER="$(id -un)"
          echo ">>> Auto-detected target user from current session: $TARGET_USER"
      fi
  fi
  
  # Validate target user
  if ! id "$TARGET_USER" >/dev/null 2>&1; then
      echo "Error: Target user '$TARGET_USER' does not exist."
      exit 1
  fi
  
  TARGET_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
  if [ -z "$TARGET_HOME" ] || [ ! -d "$TARGET_HOME" ]; then
      echo "Error: Home directory for user '$TARGET_USER' not found at '$TARGET_HOME'."
      exit 1
  fi
  
  # Ensure running as root/sudo
  if [ "$(id -u)" -ne 0 ]; then
      echo "Error: This script must be run as root or with sudo."
      exit 1
  fi
  
  # 3. Install system packages (.debs)
  echo ">>> Installing system packages (.debs)..."
  if ls debs/*.deb >/dev/null 2>&1; then
      dpkg -i debs/*.deb
  else
      echo "No .deb files found in debs/ directory."
  fi
  
  # 4. Install Neovim
  echo ">>> Installing Neovim..."
  if [ -f nvim-linux64.tar.gz ]; then
      tar -C /usr/local -xzf nvim-linux64.tar.gz --strip-components=1
  else
      echo "Warning: nvim-linux64.tar.gz not found, skipping Neovim extraction."
  fi
  
  # 5. Extract home snapshot
  echo ">>> Extracting home snapshot to $TARGET_HOME..."
  tar -xzf home_snapshot.tar.gz -C "$TARGET_HOME" \
      --owner="$TARGET_USER" \
      --group="$(id -gn "$TARGET_USER")"
  
  # 6. Setup chezmoi binary
  echo ">>> Setting up chezmoi..."
  mkdir -p "$TARGET_HOME/bin"
  cp chezmoi "$TARGET_HOME/bin/"
  chown "$TARGET_USER:$(id -gn "$TARGET_USER")" "$TARGET_HOME/bin/chezmoi"
  
  # 7. Run chezmoi apply in offline mode as target user
  echo ">>> Applying dotfiles for $TARGET_USER..."
  sudo -u "$TARGET_USER" -i "$TARGET_HOME/bin/chezmoi" apply \
      --source "$TARGET_HOME/xProfile" \
      --override-data '{"is_offline": true}'
  
  echo ">>> Offline Installation Complete!"
  ```

- [ ] **Step 2: Commit changes**

  Run:
  ```bash
  git add docker/ubuntu/install_offline.sh
  git commit -m "feat(offline): rewrite install_offline.sh to support target username specification and ownership chown"
  ```
