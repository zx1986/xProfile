export ZSH="/Users/zx1986/.oh-my-zsh"

ZSH_THEME="agnoster"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(
  git
  ruby
  rails
)

source $ZSH/oh-my-zsh.sh

# Homebrew
export PATH="/usr/local/sbin:$PATH"
export LANG=en_US.UTF-8

# Alias
source ~/.aliases
