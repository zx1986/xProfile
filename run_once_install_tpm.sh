#!/bin/sh
set -e

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "Installing Tmux Plugin Manager..."
  mkdir -p "$HOME/.tmux/plugins/"
  git clone https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm"
fi
