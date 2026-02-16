#!/bin/sh
set -e

if [ ! -d "$HOME/.zprezto" ]; then
  echo "Installing Prezto..."
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "$HOME/.zprezto"
fi
