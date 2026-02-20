#!/bin/bash
set -e

# prepare_offline_bundle.sh
#
# Run this script ON A MACHINE WITH INTERNET (Ubuntu 22.04 recommended)
# to download all assets needed for offline installation on Ubuntu 22.04.
#
# Usage:
#   ./scripts/prepare_offline_bundle.sh [--arch amd64|arm64]
#
# Output:
#   offline-packages/
#   ├── bin/              -> Standalone binaries: chezmoi, fzf, fd, bat, eza, tig
#   ├── debs/             -> .deb packages for core tools (zsh, tmux, git, etc.)
#   ├── asdf/             -> asdf version manager tarball
#   ├── prezto.tar.gz     -> Prezto with all submodules
#   ├── oh-my-tmux.tar.gz -> Oh My Tmux config
#   └── tpm.tar.gz        -> Tmux Plugin Manager

BUNDLE_DIR="$(cd "$(dirname "$0")/.." && pwd)/offline-packages"

# Detect or override architecture
if [ "${1}" = "--arch" ] && [ -n "${2}" ]; then
  ARCH="${2}"
elif command -v dpkg >/dev/null 2>&1; then
  ARCH=$(dpkg --print-architecture)
else
  # Default to amd64 for typical server installs
  ARCH="amd64"
fi

# Map dpkg arch to GitHub release arch names
if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
  BIN_ARCH="arm64"
  GNU_ARCH="aarch64-unknown-linux-gnu"
else
  BIN_ARCH="amd64"
  GNU_ARCH="x86_64-unknown-linux-gnu"
fi

echo "=== Preparing offline bundle ==="
echo "Architecture: $ARCH (binary arch: $BIN_ARCH)"
echo "Bundle directory: $BUNDLE_DIR"

rm -rf "$BUNDLE_DIR"
mkdir -p "$BUNDLE_DIR/bin" "$BUNDLE_DIR/debs" "$BUNDLE_DIR/asdf"

# ---------------------------------------------------------------------------
# .deb packages — core tools installable via apt
# ---------------------------------------------------------------------------
echo ""
echo "--- Downloading .deb packages ---"
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

sudo apt-get update -qq

# Core packages needed on a fresh Ubuntu 22.04 server
CORE_PACKAGES="zsh tmux git curl wget locales sudo unzip \
  build-essential libssl-dev libreadline-dev zlib1g-dev \
  libbz2-dev libsqlite3-dev libffi-dev liblzma-dev"

apt-get download $(apt-cache depends --recurse \
  --no-recommends --no-suggests \
  --no-conflicts --no-breaks --no-replaces --no-enhances \
  $CORE_PACKAGES 2>/dev/null \
  | grep "^\w" | sort -u) 2>/dev/null || true

if ls ./*.deb 1>/dev/null 2>&1; then
  mv ./*.deb "$BUNDLE_DIR/debs/"
  echo "Downloaded $(ls "$BUNDLE_DIR/debs/" | wc -l) .deb packages"
fi
cd -
rm -rf "$TEMP_DIR"

# ---------------------------------------------------------------------------
# Standalone binaries (GitHub releases)
# ---------------------------------------------------------------------------
echo ""
echo "--- Downloading standalone binaries ---"

_latest_tag() {
  curl -fsS "https://api.github.com/repos/$1/releases/latest" \
    | grep '"tag_name"' | head -1 | cut -d'"' -f4 | sed 's/^v//'
}

# chezmoi
echo "Downloading chezmoi..."
V=$(_latest_tag twpayne/chezmoi)
curl -fsSL "https://github.com/twpayne/chezmoi/releases/download/v${V}/chezmoi_${V}_linux_${BIN_ARCH}.tar.gz" \
  | tar xz -C "$BUNDLE_DIR/bin/" chezmoi

# fzf
echo "Downloading fzf..."
V=$(_latest_tag junegunn/fzf)
curl -fsSL "https://github.com/junegunn/fzf/releases/download/v${V}/fzf-${V}-linux_${BIN_ARCH}.tar.gz" \
  | tar xz -C "$BUNDLE_DIR/bin/"

# fd
echo "Downloading fd..."
V=$(_latest_tag sharkdp/fd)
curl -fsSL "https://github.com/sharkdp/fd/releases/download/v${V}/fd-v${V}-${GNU_ARCH}.tar.gz" \
  | tar xz --strip-components=1 -C "$BUNDLE_DIR/bin/" "fd-v${V}-${GNU_ARCH}/fd"

# bat
echo "Downloading bat..."
V=$(_latest_tag sharkdp/bat)
curl -fsSL "https://github.com/sharkdp/bat/releases/download/v${V}/bat-v${V}-${GNU_ARCH}.tar.gz" \
  | tar xz --strip-components=1 -C "$BUNDLE_DIR/bin/" "bat-v${V}-${GNU_ARCH}/bat"

# eza
echo "Downloading eza..."
V=$(_latest_tag eza-community/eza)
curl -fsSL "https://github.com/eza-community/eza/releases/download/v${V}/eza_${GNU_ARCH}.tar.gz" \
  | tar xz -C "$BUNDLE_DIR/bin/"

# tig — download the .deb directly (easier than compiling)
echo "Downloading tig..."
TIG_DEB=$(apt-cache show tig 2>/dev/null | grep "^Filename:" | head -1 | awk '{print $2}' || true)
if [ -n "$TIG_DEB" ]; then
  apt-get download tig 2>/dev/null && mv tig*.deb "$BUNDLE_DIR/debs/" || true
else
  echo "  tig not found via apt, skipping (install manually or via debs)"
fi

# ---------------------------------------------------------------------------
# asdf version manager
# ---------------------------------------------------------------------------
echo ""
echo "--- Downloading asdf ---"
ASDF_V=$(_latest_tag asdf-vm/asdf)
curl -fsSL "https://github.com/asdf-vm/asdf/releases/download/v${ASDF_V}/asdf_${ASDF_V}_linux_${BIN_ARCH}.tar.gz" \
  -o "$BUNDLE_DIR/asdf/asdf_${ASDF_V}_linux_${BIN_ARCH}.tar.gz" 2>/dev/null \
  || curl -fsSL "https://github.com/asdf-vm/asdf/archive/refs/tags/v${ASDF_V}.tar.gz" \
  -o "$BUNDLE_DIR/asdf/asdf-${ASDF_V}.tar.gz"

# ---------------------------------------------------------------------------
# Prezto (with all submodules)
# ---------------------------------------------------------------------------
echo ""
echo "--- Downloading Prezto ---"
PREZTO_TEMP=$(mktemp -d)
git clone --recursive --depth 1 https://github.com/sorin-ionescu/prezto.git "$PREZTO_TEMP/.zprezto"
tar czf "$BUNDLE_DIR/prezto.tar.gz" -C "$PREZTO_TEMP" .zprezto
rm -rf "$PREZTO_TEMP"

# ---------------------------------------------------------------------------
# Oh My Tmux
# ---------------------------------------------------------------------------
echo ""
echo "--- Downloading Oh My Tmux ---"
OMT_TEMP=$(mktemp -d)
git clone --depth 1 https://github.com/gpakosz/.tmux.git "$OMT_TEMP/oh-my-tmux"
tar czf "$BUNDLE_DIR/oh-my-tmux.tar.gz" -C "$OMT_TEMP" oh-my-tmux
rm -rf "$OMT_TEMP"

# ---------------------------------------------------------------------------
# TPM (Tmux Plugin Manager)
# ---------------------------------------------------------------------------
echo ""
echo "--- Downloading TPM ---"
TPM_TEMP=$(mktemp -d)
git clone --depth 1 https://github.com/tmux-plugins/tpm.git "$TPM_TEMP/tpm"
tar czf "$BUNDLE_DIR/tpm.tar.gz" -C "$TPM_TEMP" tpm
rm -rf "$TPM_TEMP"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo "=== Bundle complete ==="
echo "Contents:"
find "$BUNDLE_DIR" -type f | sort | while read -r f; do
  printf "  %6s  %s\n" "$(du -sh "$f" | cut -f1)" "$(echo "$f" | sed "s|$BUNDLE_DIR/||")"
done
echo ""
echo "Total: $(du -sh "$BUNDLE_DIR" | cut -f1)"
echo ""
echo "Deploy instructions:"
echo "  scp -r offline-packages/ user@host:~/.local/share/offline-packages"
echo "  scp -r xProfile/        user@host:~/xProfile"
echo "  # On target: chezmoi init --apply --source ~/xProfile"
