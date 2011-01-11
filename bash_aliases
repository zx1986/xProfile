alias ll='ls -lhF'
alias la='ls -lhA'
alias l='ls -hCF'
alias lt="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"

alias update='sudo apt-get update && sudo apt-get upgrade'
alias install='sudo apt-get install'
alias cache='apt-cache search'

alias rm='rm -i'
alias c='clear'

alias to='ssh root@$1'

alias gg='git pull origin master && git add . && git commit -a && git push'

alias work='cd ~/Projects && tmux'

alias mysql_backup='for I in $(mysql -e "show databases" -s --skip-column-names); do mysqldump $I | gzip > "$I.sql.gz"; done'
