init:
	@touch $(HOME)/.aliases && rm -i $(HOME)/.aliases
	ln -s $(PWD)/aliases $(HOME)/.aliases
	@touch $(HOME)/.bashrc && rm -i $(HOME)/.bashrc
	ln -s $(PWD)/bashrc $(HOME)/.bashrc
	@touch $(HOME)/.vimrc && rm -i $(HOME)/.vimrc
	ln -s $(PWD)/vimrc $(HOME)/.vimrc
	@touch $(HOME)/.vim && rm -i $(HOME)/.vim
	ln -s $(PWD)/vim $(HOME)/.vim
	@touch $(HOME)/.gitcompletion && rm -i $(HOME)/.gitcompletion
	ln -s $(PWD)/gitcompletion $(HOME)/.gitcompletion
	@touch $(HOME)/.gitconfig && rm -i $(HOME)/.gitconfig
	ln -s $(PWD)/gitconfig $(HOME)/.gitconfig
	@touch $(HOME)/.fonts.conf && rm -i $(HOME)/.fonts.conf
	ln -s $(PWD)/fonts.conf $(HOME)/.fonts.conf
	@touch $(HOME)/.zshrc && rm -i $(HOME)/.zshrc
	ln -s $(PWD)/zshrc $(HOME)/.zshrc
