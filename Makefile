deploy:
	rm -rf $(HOME)/.bashrc
	rm -rf $(HOME)/.vimrc
	rm -rf $(HOME)/.vim
	ln -s $(PWD)/vim $(HOME)/.vim
	ln -s $(PWD)/vimrc $(HOME)/.vimrc
	ln -s $(PWD)/bashrc $(HOME)/.bashrc
