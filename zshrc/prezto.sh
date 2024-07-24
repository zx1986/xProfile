#!/usr/bin/env zsh

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

git clone https://github.com/agkozak/zsh-z.git ~/.zprezto-contrib/zsh-z

cat <<EOF >> ${ZDOTDIR:-$HOME}/.zshrc
autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit

source $(PWD)/zshrc/zsh_pre_setup
source $(PWD)/zshrc/omz-git.zsh
source $(PWD)/zshrc/omz-git.plugin.zsh
source $(PWD)/zshrc/omz-kube-ps1.plugin.zsh
source $(PWD)/zshrc/omz-kubectl.plugin.zsh
source $(PWD)/zshrc/zsh_post_setup
EOF

# https://github.com/sorin-ionescu/prezto
# https://wikimatze.de/better-zsh-with-prezto/
