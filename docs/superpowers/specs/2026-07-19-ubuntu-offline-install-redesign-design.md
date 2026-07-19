# Design Spec: Ubuntu Offline Installation Redesign

## Overview

This specification details improvements to the Ubuntu offline installation package to exclude the Antigravity CLI (`agy`), ensure complete pre-installation of all Neovim plugins, Mason LSPs, and Treesitter parsers, and add support for specifying the target username during offline installation.

## Context

* **Repository**: xProfile
* **Goal**: Refine offline Ubuntu dotfiles installation to:
  1. Completely exclude the Antigravity CLI and its plugins from offline setups.
  2. Guarantee that Neovim plugins, Mason LSPs (`lua-language-server`, `stylua`, `html-lsp`, `css-lsp`, `prettier`), and Treesitter parsers are fully cached offline.
  3. Support multi-user target environments by allowing the installer to specify/auto-detect the destination username on Ubuntu.

---

## Proposed Changes

### 1. Excluding Antigravity (`agy`)

#### 1.1 `run_once_before_06_install_antigravity.sh.tmpl`
We will wrap the entire template script in a conditional block to skip installation entirely when `is_offline` is true:
```bash
{{- if not (index . "is_offline") }}
#!/bin/bash
set -e
# (Original online install script contents)
{{- end }}
```
In offline mode, this renders as an empty script and Chezmoi does not execute it.

#### 1.2 `docker/ubuntu/Dockerfile.bundle`
Right before taking the home snapshot, we will delete the pre-installed `agy` binary and config folders from the builder user's home directory:
```dockerfile
RUN rm -rf /home/user/.local/bin/agy /home/user/.gemini
```

---

### 2. Neovim Offline Hydration

We will update [docker/ubuntu/Dockerfile.bundle](file:///home/zx1986/Projects/dotfiles/docker/ubuntu/Dockerfile.bundle) to warm up Neovim with all configured Mason LSPs and Treesitter parsers synchronously:
```dockerfile
RUN nvim --headless "+Lazy! sync" "+TSUpdateSync" "+MasonInstall lua-language-server stylua html-lsp css-lsp prettier" +qa
```
* Using `TSUpdateSync` ensures Treesitter parsers (`vim`, `lua`, `vimdoc`, `html`, `css`) are compiled synchronously during build.
* Explicitly invoking `MasonInstall` for all 5 LSPs guarantees they are cached in `/home/user/.local/share/nvim/mason`.

---

### 3. Username-Aware Installer Script

We will rewrite [docker/ubuntu/install_offline.sh](file:///home/zx1986/Projects/dotfiles/docker/ubuntu/install_offline.sh) to handle the target username:

#### 3.1 Argument Parsing & Auto-detection
* Parse `-u | --user <username>` flags.
* If omitted, fall back to `$SUDO_USER` (when run via `sudo`) or `$(id -un)`.
* Validate that the target user exists.
* Retrieve the target user's home directory path.

#### 3.2 Permission Isolation
* Extract `home_snapshot.tar.gz` to the target user's home directory using GNU `tar` options to enforce target user ownership on extraction:
  ```bash
  tar -xzf home_snapshot.tar.gz -C "$TARGET_HOME" --owner="$TARGET_USER" --group="$(id -gn "$TARGET_USER")"
  ```
* Copy the `chezmoi` binary to `$TARGET_HOME/bin/chezmoi` and set its ownership.
* Run the final Chezmoi apply command inside the target user's context:
  ```bash
  sudo -u "$TARGET_USER" -i "$TARGET_HOME/bin/chezmoi" apply --source "$TARGET_HOME/xProfile" --override-data '{"is_offline": true}'
  ```

---

## Verification Plan

1. **Verify template rendering (simulation)**:
   * Run `make test` to ensure Chezmoi successfully compiles all templates.
   * Modify `tests/suite_common.sh` to remove the outdated `agy` plugin presence check, and add a test verifying that `06_install_antigravity.sh` is empty when `is_offline: true`.

2. **Verify Offline Installer behavior**:
   * Create a dummy user on the system: `sudo useradd -m -s /bin/zsh testuser`.
   * Execute the installer targeting the dummy user: `sudo ./install.sh --user testuser`.
   * Verify:
     * System packages are successfully installed via dpkg.
     * All Neovim plugins, Mason LSPs, and Treesitter parsers are located in `/home/testuser/.local/share/nvim`.
     * Zsh configurations are successfully rendered.
     * No Antigravity directories or binaries (`agy`) are present.
     * All home files are owned by `testuser:testuser`.
