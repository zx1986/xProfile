#!/bin/bash

apt='sudo apt-get install'

network='nmap iftop nethogs netcat ngrep iptraf curl'
web='tsung siege'
coding='vim vim-doc ack-grep ack git git-doc'
system='openssh-server htop dstat sysv-rc-conf mosh bum guake'
game='slashem nethack-console nethack-x11'

${apt} ${network} ${system} ${coding} ${web}
