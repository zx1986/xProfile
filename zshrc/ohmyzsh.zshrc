# ENV
export GOPATH=$HOME/go
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=UTF-8
export FZF_BASE="/usr/local/bin/fzf"
export ZSH="${HOME}/.oh-my-zsh"

# PATH
export PATH="${HOME}/bin:/usr/local/bin:/usr/local/sbin:${PATH}"
export PATH="/usr/local/opt/nss/bin:$PATH"
export PATH="/usr/local/opt/ncurses/bin:$PATH"
export PATH="/usr/local/opt/gettext/bin:$PATH"
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export PATH=$PATH:$GOPATH/bin

# Completions
fpath=(/usr/local/share/zsh-completions $fpath)
fpath=(/usr/local/share/zsh/site-functions $fpath)

# Plugins
plugins=(
  zsh-completion
  zsh-autosuggestions
  zsh-syntax-highlighting
  history-substring-search
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
  fzf
  pj
  k
  z
  django
  thefuck
)

# ZSH_THEME="ys"
# ZSH_THEME="agnoster"
# ZSH_THEME="robbyrussell"
ZSH_THEME="spaceship"

SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_PROMPT_SEPARATE_LINE=true
SPACESHIP_VI_MODE_SHOW=true
SPACESHIP_PROMPT_ORDER=(
  # time        # Time stamps section (Disabled)
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  # hg          # Mercurial section (hg_branch  + hg_status)
  # package     # Package version (Disabled)
  node          # Node.js section
  ruby          # Ruby section
  # elixir      # Elixir section
  # xcode       # Xcode section (Disabled)
  # swift       # Swift section
  golang        # Go section
  php           # PHP section
  # rust        # Rust section
  # haskell     # Haskell Stack section
  # julia       # Julia section (Disabled)
  docker        # Docker section (Disabled)
  aws           # Amazon Web Services section
  # venv        # virtualenv section
  # conda       # conda virtualenv section
  # pyenv       # Pyenv section
  # dotne       # .NET section
  # ember       # Ember.js section (Disabled)
  kubecontext   # Kubectl context section
  terraform     # Terraform workspace section
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  vi_mode       # Vi-mode indicator (Disabled)
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

# ENABLE_CORRECTION="true"
# CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"
PROJECT_PATHS=(~/Sites ~/Projects/Larvata)

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_rsa

# zstyle -g existing_commands ':completion:*:*:git:*' user-commands
# zstyle ':completion:*:*:git:*' user-commands $existing_commands flow:'provide high-level repository operations'

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

# Init oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Using exa instead of ls
alias ls='exa'
alias ll='ls -lh'
alias la='ls -AF'
