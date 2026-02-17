#!/bin/sh
set -e

# Install Oh My Tmux (gpakosz/.tmux)
if [ ! -d "$HOME/.tmux" ]; then
  OFFLINE_DIR="$HOME/.local/share/offline-packages"

  if [ -f "$OFFLINE_DIR/oh-my-tmux.tar.gz" ]; then
    echo "Installing Oh My Tmux from offline bundle..."
    tar xzf "$OFFLINE_DIR/oh-my-tmux.tar.gz" -C "$HOME"
    # Tarball extracts to "oh-my-tmux", rename to ".tmux"
    mv "$HOME/oh-my-tmux" "$HOME/.tmux"
  elif command -v git >/dev/null; then
    echo "Installing Oh My Tmux from GitHub..."
    git clone --depth=1 https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
  else
    echo "WARN: Cannot install Oh My Tmux (no git, no offline bundle)"
  fi
fi
