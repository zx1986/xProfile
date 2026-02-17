#!/bin/bash
set -e

# prepare_offline_bundle.sh
#
# Run this script ON A MACHINE WITH INTERNET to download all assets
# needed for offline installation on Ubuntu 22.04.
#
# Usage:
#   ./scripts/prepare_offline_bundle.sh
#
# It creates:
#   offline-packages/
#   ├── bin/           -> Standalone binaries (chezmoi, fzf, fd, eza, bat, tig)
#   ├── debs/          -> .deb packages for apt
#   ├── prezto.tar.gz  -> Prezto snapshot
#   └── tpm.tar.gz     -> Tmux Plugin Manager snapshot

BUNDLE_DIR="$(cd "$(dirname "$0")/.." && pwd)/offline-packages"
ARCH=$(dpkg --print-architecture 2>/dev/null || echo "arm64")

echo "=== Preparing offline bundle ==="
echo "Architecture: $ARCH"
echo "Bundle directory: $BUNDLE_DIR"

rm -rf "$BUNDLE_DIR"
mkdir -p "$BUNDLE_DIR/bin" "$BUNDLE_DIR/debs"

# --- Download .deb packages ---
echo ""
echo "--- Downloading .deb packages ---"
# Create a temporary directory for apt download
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download packages and their dependencies
sudo apt-get update
apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances \
  zsh tmux git curl locales sudo 2>/dev/null | grep -v "^[< ]" | sort -u) 2>/dev/null || true

# Copy only .deb files
if ls *.deb 1>/dev/null 2>&1; then
    mv *.deb "$BUNDLE_DIR/debs/"
    echo "Downloaded $(ls "$BUNDLE_DIR/debs/" | wc -l) .deb packages"
fi
cd -
rm -rf "$TEMP_DIR"

# --- Download standalone binaries ---
echo ""
echo "--- Downloading standalone binaries ---"

# chezmoi
echo "Downloading chezmoi..."
CHEZMOI_VERSION=$(curl -s https://api.github.com/repos/twpayne/chezmoi/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/^v//')
if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
    CHEZMOI_ARCH="arm64"
else
    CHEZMOI_ARCH="amd64"
fi
curl -fsSL "https://github.com/twpayne/chezmoi/releases/download/v${CHEZMOI_VERSION}/chezmoi_${CHEZMOI_VERSION}_linux_${CHEZMOI_ARCH}.tar.gz" | tar xz -C "$BUNDLE_DIR/bin/" chezmoi

# fzf
echo "Downloading fzf..."
FZF_VERSION=$(curl -s https://api.github.com/repos/junegunn/fzf/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/^v//')
curl -fsSL "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_${CHEZMOI_ARCH}.tar.gz" | tar xz -C "$BUNDLE_DIR/bin/"

# fd
echo "Downloading fd..."
FD_VERSION=$(curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/^v//')
if [ "$CHEZMOI_ARCH" = "arm64" ]; then
    FD_TARGET="aarch64-unknown-linux-gnu"
else
    FD_TARGET="x86_64-unknown-linux-gnu"
fi
curl -fsSL "https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-v${FD_VERSION}-${FD_TARGET}.tar.gz" | tar xz --strip-components=1 -C "$BUNDLE_DIR/bin/" "fd-v${FD_VERSION}-${FD_TARGET}/fd"

# bat
echo "Downloading bat..."
BAT_VERSION=$(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/^v//')
if [ "$CHEZMOI_ARCH" = "arm64" ]; then
    BAT_TARGET="aarch64-unknown-linux-gnu"
else
    BAT_TARGET="x86_64-unknown-linux-gnu"
fi
curl -fsSL "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-${BAT_TARGET}.tar.gz" | tar xz --strip-components=1 -C "$BUNDLE_DIR/bin/" "bat-v${BAT_VERSION}-${BAT_TARGET}/bat"

# eza
echo "Downloading eza..."
EZA_VERSION=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/^v//')
if [ "$CHEZMOI_ARCH" = "arm64" ]; then
    EZA_TARGET="aarch64-unknown-linux-gnu"
else
    EZA_TARGET="x86_64-unknown-linux-gnu"
fi
curl -fsSL "https://github.com/eza-community/eza/releases/download/v${EZA_VERSION}/eza_${EZA_TARGET}.tar.gz" | tar xz -C "$BUNDLE_DIR/bin/"

# --- Download Prezto ---
echo ""
echo "--- Downloading Prezto ---"
PREZTO_TEMP=$(mktemp -d)
git clone --recursive --depth 1 https://github.com/sorin-ionescu/prezto.git "$PREZTO_TEMP/.zprezto"
tar czf "$BUNDLE_DIR/prezto.tar.gz" -C "$PREZTO_TEMP" .zprezto
rm -rf "$PREZTO_TEMP"

# --- Download TPM ---
echo ""
echo "--- Downloading TPM ---"
TPM_TEMP=$(mktemp -d)
git clone --depth 1 https://github.com/tmux-plugins/tpm.git "$TPM_TEMP/tpm"
tar czf "$BUNDLE_DIR/tpm.tar.gz" -C "$TPM_TEMP" tpm
rm -rf "$TPM_TEMP"

echo ""
echo "=== Bundle complete ==="
echo "Contents of $BUNDLE_DIR:"
find "$BUNDLE_DIR" -type f | sort | while read f; do
    size=$(du -h "$f" | cut -f1)
    echo "  $size  $(echo "$f" | sed "s|$BUNDLE_DIR/||")"
done
echo ""
echo "Total size: $(du -sh "$BUNDLE_DIR" | cut -f1)"
echo ""
echo "To deploy on an offline Ubuntu machine:"
echo "  1. Copy $BUNDLE_DIR to the target machine at ~/.local/share/offline-packages"
echo "  2. Copy the xProfile repo to ~/xProfile"
echo "  3. Run: chezmoi init --apply --source ~/xProfile"
