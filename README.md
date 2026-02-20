# xProfile — Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/). Supports macOS and Ubuntu 22.04, with full offline installation.

---

## Setup

### macOS

```sh
brew install chezmoi
chezmoi init --apply --source ~/xProfile
```

### Ubuntu 22.04 — Online

```sh
# Install chezmoi
curl -fsLS get.chezmoi.io | sh
# Apply dotfiles (git and other tools must be available)
~/bin/chezmoi init --apply --source ~/xProfile
```

### Ubuntu 22.04 — Offline

**On a machine with internet** (Ubuntu 22.04 recommended to match package versions):

```sh
./scripts/prepare_offline_bundle.sh          # defaults to amd64
./scripts/prepare_offline_bundle.sh --arch arm64  # for ARM servers / Apple Silicon VMs
```

**Transfer to the target machine:**

```sh
scp -r offline-packages/ user@host:~/.local/share/offline-packages
scp -r xProfile/         user@host:~/xProfile
```

**On the offline target:**

```sh
# chezmoi is inside the offline bundle
~/.local/share/offline-packages/bin/chezmoi init --apply --source ~/xProfile
```

---

## Project Layout

```
xProfile/
├── dot_*                        # Dotfiles managed by chezmoi
├── dot_zshrc.tmpl               # Main zsh config (OS-aware template)
├── dot_zpreztorc                # Prezto module config
├── dot_gitconfig.tmpl           # Git config (OS-aware)
├── dot_tmux.conf.local          # Oh My Tmux user customization
├── symlink_dot_tmux.conf        # ~/.tmux.conf → ~/.tmux/.tmux.conf
├── .chezmoitemplates/
│   ├── zsh_pre_setup            # OS-specific env vars & paths
│   └── zsh_post_setup           # Tools, functions, plugin sourcing
├── dot_config/zsh/parts/        # Bundled zsh plugins (sourced by zshrc)
│   ├── omz-git.plugin.zsh
│   ├── omz-kubectl.plugin.zsh
│   ├── omz-kube-ps1.plugin.zsh
│   ├── omz-aws.plugin.zsh
│   ├── omz-terraform.plugin.zsh
│   ├── mysql-colorize.plugin.zsh
│   └── solarized-man.plugin.zsh
├── completions/zsh/_eza         # eza zsh completion (→ Prezto)
├── run_once_install_packages.sh.tmpl
├── run_once_install_prezto.sh
├── run_once_install_oh_my_tmux.sh
├── scripts/
│   └── prepare_offline_bundle.sh
└── docker/ubuntu/               # Offline verification environment
    ├── Dockerfile
    ├── docker-compose.yml
    └── verify.sh
```

---

## Offline Bundle Contents

`prepare_offline_bundle.sh` downloads:

| Asset | Source |
|---|---|
| `bin/chezmoi` | github.com/twpayne/chezmoi |
| `bin/fzf` | github.com/junegunn/fzf |
| `bin/fd` | github.com/sharkdp/fd |
| `bin/bat` | github.com/sharkdp/bat |
| `bin/eza` | github.com/eza-community/eza |
| `debs/tig` | Ubuntu apt |
| `debs/*.deb` | Core: zsh, tmux, git, curl, build-essential |
| `asdf/*.tar.gz` | github.com/asdf-vm/asdf |
| `prezto.tar.gz` | github.com/sorin-ionescu/prezto (recursive) |
| `oh-my-tmux.tar.gz` | github.com/gpakosz/.tmux |
| `tpm.tar.gz` | github.com/tmux-plugins/tpm |

---

## Docker Verification

```sh
cd docker/ubuntu

# Build image (downloads all apt deps during build)
docker compose build

# Start container
docker compose up -d

# Run full verification (online mode)
docker exec dotfiles_ubuntu_verify bash ~/xProfile/docker/ubuntu/verify.sh

# Run full verification (offline mode — needs offline-packages/ bundle mounted)
docker exec dotfiles_ubuntu_verify bash ~/xProfile/docker/ubuntu/verify.sh --offline

# Interactive shell
docker exec -it dotfiles_ubuntu_verify zsh
```

---

## Reference

- https://www.chezmoi.io/
- https://github.com/gpakosz/.tmux
- https://github.com/sorin-ionescu/prezto
