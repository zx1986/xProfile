#!/bin/sh
set -e

# Install TPM (from offline bundle or git clone)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  OFFLINE_DIR="$HOME/.local/share/offline-packages"
  mkdir -p "$HOME/.tmux/plugins/"

  if [ -f "$OFFLINE_DIR/tpm.tar.gz" ]; then
    echo "Installing TPM from offline bundle..."
    tar xzf "$OFFLINE_DIR/tpm.tar.gz" -C "$HOME/.tmux/plugins/"
  elif command -v git >/dev/null; then
    echo "Installing TPM from GitHub..."
    git clone https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm"
  else
    echo "WARN: Cannot install TPM (no git, no offline bundle)"
  fi
fi
