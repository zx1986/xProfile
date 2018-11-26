# LANG
set -xg LANG en_US.UTF-8

# Golang developers might need this one
set -xg GOPATH $HOME/go

# Python developers otherwise
set -xg PYTHONDONTWRITEBYTECODE 1

# Homebrew read Github
set -xg HOMEBREW_GITHUB_API_TOKEN 3d3923cdd4a8690e668dfd9369f9dfed95c66d6f

# PATH
set -gx PATH \
        $PATH \
        $GOPATH/bin \
        /usr/local/opt/nss/bin \
        /usr/local/opt/ncurses/bin \
        /usr/local/opt/gettext/bin \
        /usr/local/opt/mysql-client/bin \
        /usr/local/opt/go/libexec/bin

set -g fish_user_paths "/usr/local/sbin" $fish_user_paths

# pj
set -gx PROJECT_PATHS ~/Projects ~/Sites

# Ruby
set PATH $HOME/.rbenv/bin $PATH
set PATH $HOME/.rbenv/shims $PATH
rbenv rehash >/dev/null ^&1

# gitignore.io
function gi
	curl -L -s https://www.gitignore.io/api/$argv
end

# Custom aliases
source ~/.aliases
