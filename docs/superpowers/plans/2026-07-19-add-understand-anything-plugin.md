# Add Understand-Anything Plugin Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `https://github.com/Egonex-AI/Understand-Anything` to the antigravity plugins configuration in the dotfiles so it is automatically installed via Chezmoi.

**Architecture:** Update the `.chezmoidata.yaml` data file to append the plugin URL to the `antigravity.plugins` array. Add a test check in `tests/suite_common.sh` to verify the plugin is successfully rendered in the installer script, and run verification.

**Tech Stack:** Chezmoi templates, bash, bats

---

### Task 1: Update Configuration and Add Verification Test

**Files:**
- Modify: `.chezmoidata.yaml`
- Modify: `tests/suite_common.sh`

- [ ] **Step 1: Write a failing test in `tests/suite_common.sh`**

  Modify [tests/suite_common.sh](file:///home/zx1986/Projects/dotfiles/tests/suite_common.sh) to add an assertion that the installation script references the `Understand-Anything` plugin:

  ```diff
   # Add some checks for directories we expect to exist
   check ".tmux.conf.local exists" "[[ -f \$TMP_HOME/.tmux.conf.local ]]"
   check "antigravity installation script rendered" "[[ -f \$TMP_HOME/06_install_antigravity.sh ]]"
+  check "antigravity installation script installs Egonex-AI/Understand-Anything" "grep -q 'Understand-Anything' \$TMP_HOME/06_install_antigravity.sh"
  ```

- [ ] **Step 2: Run test to verify it fails**

  Run:
  ```bash
  make test
  ```
  Expected: FAIL, with output indicating that the test "antigravity installation script installs Egonex-AI/Understand-Anything" failed.

- [ ] **Step 3: Update `.chezmoidata.yaml` to include the plugin**

  Modify [.chezmoidata.yaml](file:///home/zx1986/Projects/dotfiles/.chezmoidata.yaml) to add the `Understand-Anything` plugin:

  ```diff
   antigravity:
     plugins:
       - https://github.com/obra/superpowers
       - https://github.com/DietrichGebert/ponytail
+      - https://github.com/Egonex-AI/Understand-Anything
  ```

- [ ] **Step 4: Run test to verify it passes**

  Run:
  ```bash
  make test
  ```
  Expected: PASS

- [ ] **Step 5: Run health check to ensure everything is functional**

  Run:
  ```bash
  make health
  ```
  Expected: Success or baseline behavior (the pre-existing Spaceship theme failure might persist, but no new failure).

- [ ] **Step 6: Commit changes**

  Run:
  ```bash
  git add .chezmoidata.yaml tests/suite_common.sh
  git commit -m "feat: add Egonex-AI/Understand-Anything plugin to antigravity config"
  ```
