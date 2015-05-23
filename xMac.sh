#!/bin/sh

system='the_silver_searcher tmux mosh htop'
coding='vim git git-flow-avh tig'
shell='zsh fish'
ruby='rbenv ruby-build'
toys='archey cowsay figlet'

brew install ${system} ${shell} ${coding} ${ruby} ${toys}
