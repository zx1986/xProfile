# LANG
set -xg LANG en_US.UTF-8

# Golang developers might need this one
set -xg GOPATH $HOME/go

# Python developers otherwise
set -xg PYTHONDONTWRITEBYTECODE 1

# Homebrew read Github
set -xg HOMEBREW_GITHUB_API_TOKEN super_secret_token

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

# gitignore.io
function gi
	curl -L -s https://www.gitignore.io/api/$argv
end

# Custom aliases
source ~/.aliases
