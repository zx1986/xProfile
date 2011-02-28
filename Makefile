init:
	rm -rf $(HOME)/.bash_aliases
	rm -rf $(HOME)/.bashrc
	rm -rf $(HOME)/.vimrc
	rm -rf $(HOME)/.vim
	ln -s $(PWD)/vim $(HOME)/.vim
	ln -s $(PWD)/vimrc $(HOME)/.vimrc
	ln -s $(PWD)/bashrc $(HOME)/.bashrc
	ln -s $(PWD)/bash_aliases $(HOME)/.bash_aliases
	rm -rf $(HOME)/.fonts.conf
	ln -s $(PWD)/fonts.conf $(HOME)/.fonts.conf
	cp $(PWD)/LiHeiPro.ttf $(HOME)/.fonts/
