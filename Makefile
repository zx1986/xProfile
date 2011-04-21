init:
	@touch $(HOME)/.bash_aliases
	rm -i $(HOME)/.bash_aliases
	ln -s $(PWD)/bash_aliases $(HOME)/.bash_aliases
	@touch $(HOME)/.bashrc
	rm -i $(HOME)/.bashrc
	ln -s $(PWD)/bashrc $(HOME)/.bashrc
	@touch $(HOME)/.vimrc
	rm -i $(HOME)/.vimrc
	ln -s $(PWD)/vimrc $(HOME)/.vimrc
	@touch $(HOME)/.vim
	rm -i $(HOME)/.vim
	ln -s $(PWD)/vim $(HOME)/.vim
	@touch $(HOME)/.git-completion.bash
	rm -i $(HOME)/.git-completion.bash
	ln -s $(PWD)/git-completion.bash $(HOME)/.git-completion.bash
	@touch $(HOME)/.gitconfig
	rm -i $(HOME)/.gitconfig
	ln -s $(PWD)/gitconfig $(HOME)/.gitconfig
	@touch $(HOME)/.fonts.conf
	rm -i $(HOME)/.fonts.conf
	ln -s $(PWD)/fonts.conf $(HOME)/.fonts.conf
