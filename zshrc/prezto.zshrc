# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

# Git
function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

# Ruby
eval "$(rbenv init -)"

# iTerm
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# z
[ -f /usr/local/etc/profile.d/z.sh ] && source /usr/local/etc/profile.d/z.sh

# Fuck
eval $(thefuck --alias)

# History
#setopt BANG_HIST                 # Treat the '!' character specially during expansion.
#setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
#setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
#setopt SHARE_HISTORY             # Share history between all sessions.
#setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
#setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
#setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
#setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
#setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
#setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
#setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
#setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
#setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# Others
source ~/.aliases
fpath=(/usr/local/share/zsh-completions $fpath)
