### Custom pre-setup

[ -f ~/.z-pre-setup ] && source ~/.z-pre-setup

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
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match

zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

# 0 -- vanilla completion (abc => abc)
# 1 -- smart case completion (abc => Abc)
# 2 -- word flex completion (abc => A-big-Car)
# 3 -- full flex completion (abc => ABraCadabra)
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

### Keybindings

# bindkey -v # vi
bindkey -e # emacs
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
#antibody bundle zsh-users/zsh-syntax-highlighting
antibody bundle zsh-users/zsh-autosuggestions
antibody bundle zsh-users/zsh-completions
antibody bundle petervanderdoes/git-flow-completion
antibody bundle zdharma/fast-syntax-highlighting
antibody bundle rluders/laradock-workspace-zsh
antibody bundle horosgrisa/mysql-colorize
antibody bundle zlsun/solarized-man
antibody bundle voronkovich/project.plugin.zsh
antibody bundle supercrabtree/k
antibody bundle zpm-zsh/ssh
antibody bundle twang817/zsh-ssh-agent
antibody bundle pbar1/zsh-terraform
antibody bundle denysdovhan/spaceship-prompt
antibody bundle gantsign/zsh-plugins path:ctop kind:fpath
antibody bundle gantsign/zsh-plugins path:bat kind:fpath

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent osx-use-launchd-ssh-agent yes

### Custom post-setup

[ -f ~/.z-post-setup ] && source ~/.z-post-setup
