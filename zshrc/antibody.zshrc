### ENV

export VISUAL='nvim'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=UTF-8
export GOPATH=$HOME/go
export FZF_BASE="/usr/local/bin/fzf"
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -U -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

### PATH

export PATH="${HOME}/bin:/usr/local/bin:/usr/local/sbin:${PATH}"
export PATH="/usr/local/opt/nss/bin:$PATH"
export PATH="/usr/local/opt/ncurses/bin:$PATH"
export PATH="/usr/local/opt/gettext/bin:$PATH"
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export PATH=$PATH:$GOPATH/bin

### Auto Completions

autoload -Uz compinit

typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

zmodload -i zsh/complist

### Options

# ENABLE_CORRECTION="true"
# CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE

setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances of the shell
setopt auto_cd # cd by typing directory name if it's not a command
setopt correct_all # autocorrect commands
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match

zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

### Keybindings

bindkey '^[[3~' delete-char
bindkey '^[3;5~' delete-char

### Spaceship Theme

SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_PROMPT_SEPARATE_LINE=true
SPACESHIP_VI_MODE_SHOW=false

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
  # battery     # Battery level and status
  vi_mode       # Vi-mode indicator (Disabled)
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

# Simplify prompt if we're using Hyper
if [[ "$TERM_PROGRAM" == "Hyper" ]]; then
  SPACESHIP_PROMPT_SEPARATE_LINE=false
  SPACESHIP_DIR_SHOW=false
  SPACESHIP_GIT_BRANCH_SHOW=false
fi

### Plugins

# Load antibody plugin manager
source <(antibody init)
antibody bundle zsh-users/zsh-history-substring-search
antibody bundle zsh-users/zsh-autosuggestions
antibody bundle zsh-users/zsh-completions
antibody bundle petervanderdoes/git-flow-completion
antibody bundle zdharma/fast-syntax-highlighting
antibody bundle supercrabtree/k
antibody bundle denysdovhan/spaceship-prompt

# Ruby
eval "$(rbenv init -)"

# iTerm
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Alias
source ~/.aliases

# Using exa instead of ls
alias ls='exa'
alias ll='ls -lh'
alias la='ls -AF'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
