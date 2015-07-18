#!/bin/sh

system='the_silver_searcher tmux mosh htop'
coding='vim git git-flow-avh tig'
shell='zsh fish'
ruby='rbenv ruby-build'
toys='archey cowsay figlet'

brew install ${system} ${shell} ${coding} ${ruby} ${toys}

brew install caskroom/cask/brew-cask
brew cask install atom
brew cask install skype
brew cask install iterm2
brew cask install firefox
brew cask install google-chrome
brew cask install virtualbox
brew cask install vagrant
