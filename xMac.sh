#!/bin/sh

system='fzf tmux mosh htop'
coding='vim git git-flow-avh tig'
shell='zsh antigen'
ruby='rbenv ruby-build'
toys='archey cowsay figlet'

brew install "${system}" "${shell}" "${coding}" "${ruby}" "${toys}"

brew install caskroom/cask/brew-cask
brew cask install skype
brew cask install iterm2
