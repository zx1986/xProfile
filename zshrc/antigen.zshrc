### Custom pre-setup

[ -f .z-pre-setup ] && source ~/.z-pre-setup

###

source /usr/local/share/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle brew
antigen bundle capistrano
antigen bundle colorize
antigen bundle docker
antigen bundle docker-compose
antigen bundle emoji
antigen bundle emoji-clock
antigen bundle gem
antigen bundle git-extras
antigen bundle git-flow-avh
antigen bundle git-remote-branch
antigen bundle gitignore
antigen bundle history
antigen bundle history-substring-search
antigen bundle httpie
antigen bundle iwhois
antigen bundle mosh
antigen bundle osx
antigen bundle rbenv
antigen bundle ruby
antigen bundle rake
antigen bundle rails
antigen bundle rsync
antigen bundle tig
antigen bundle tmux
antigen bundle tmuxinator

# https://github.com/unixorn/awesome-zsh-plugins#plugins
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle trapd00r/zsh-syntax-highlighting-filetypes
antigen bundle Seinh/git-prune
antigen bundle unixorn/git-extra-commands
antigen bundle voronkovich/gitignore.plugin.zsh

# https://github.com/unixorn/awesome-zsh-plugins#even-more-completions
antigen bundle bobthecow/git-flow-completion

# Load the theme.
# antigen theme robbyrussell/oh-my-zsh themes/apple
# antigen theme robbyrussell
antigen theme ys

# Tell antigen that you're done.
antigen apply

### Custom post-setup

[ -f .z-post-setup ] && source ~/.z-post-setup
