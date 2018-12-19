# ENV
export GOPATH=$HOME/go
export LANG=en_US.UTF-8
export ZSH="${HOME}/.oh-my-zsh"

# PATH
export PATH="${HOME}/bin:/usr/local/bin:/usr/local/sbin:${PATH}"
export PATH="/usr/local/opt/nss/bin:$PATH"
export PATH="/usr/local/opt/ncurses/bin:$PATH"
export PATH="/usr/local/opt/gettext/bin:$PATH"
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export PATH=$PATH:$GOPATH/bin

# Plugins
plugins=(
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-completion
  git
  gitignore
  git-extras
  git-flow-avh
  git-flow-completion
  docker
  vi-mode
  compleat
  colored-man-pages
  ssh-agent
  urltools
  osx
  pj
  k
  z
  rails
  django
  history-substring-search
)

ZSH_THEME="ys"
ZSH_THEME="agnoster"
ZSH_THEME="robbyrussell"

# ENABLE_CORRECTION="true"
# CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"
PROJECT_PATHS=(~/Sites ~/Projects/Larvata)

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_rsa id_github id_bitbucket

# zstyle -g existing_commands ':completion:*:*:git:*' user-commands
# zstyle ':completion:*:*:git:*' user-commands $existing_commands flow:'provide high-level repository operations'

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Ruby
eval "$(rbenv init -)"

# iTerm
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Alias
source ~/.aliases
