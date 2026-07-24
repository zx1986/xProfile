# Design Spec: Add Skills Antigravity Plugin

## Overview

This specification details adding the `skills` Antigravity plugin to the dotfiles configuration so it is automatically installed during Chezmoi initialization and update.

## Context

* **Repository**: xProfile
* **Goal**: Add `https://github.com/mattpocock/skills` to `antigravity.plugins` in `.chezmoidata.yaml`.

---

## Proposed Changes

### 1. `.chezmoidata.yaml`

Modify `.chezmoidata.yaml` to include the new plugin in the list:

```yaml
antigravity:
  plugins:
    - https://github.com/obra/superpowers
    - https://github.com/DietrichGebert/ponytail
    - https://github.com/Egonex-AI/Understand-Anything
    - https://github.com/mattpocock/skills
```

### 2. `tests/suite_common.sh`

Add a test check to verify that the generated `06_install_antigravity.sh` script references the `skills` plugin:

```diff
 check "antigravity installation script rendered" "[[ -f \$TMP_HOME/06_install_antigravity.sh ]]"
 check "antigravity installation script installs Egonex-AI/Understand-Anything" "grep -q 'Understand-Anything' \$TMP_HOME/06_install_antigravity.sh"
+check "antigravity installation script installs mattpocock/skills" "grep -q 'mattpocock/skills' \$TMP_HOME/06_install_antigravity.sh"
```

---

## Verification Plan

1. Run `make test` to verify that Chezmoi templates render successfully and tests pass.
2. Run `make update` (or `chezmoi apply`) to trigger Chezmoi update and install the plugin.
3. Verify that `agy plugin install` runs and successfully installs `https://github.com/mattpocock/skills`.
