init:
	git submodule init
	git submodule update
	ln -s $(PWD)/ubuntu/fonts.conf $(HOME)/.fonts.conf
	ln -s $(PWD)/ubuntu/aliases $(HOME)/.aliases
	ln -s $(PWD)/ubuntu/bashrc $(HOME)/.bashrc
	ln -s $(PWD)/ubuntu/zshrc $(HOME)/.zshrc
	ln -s $(PWD)/oh-my-zsh $(HOME)/.oh-my-zsh
	ln -s $(PWD)/vim $(HOME)/.vim
	ln -s $(PWD)/vim/vimrc $(HOME)/.vimrc
	ln -s $(PWD)/git/git-config $(HOME)/.gitconfig
	ln -s $(PWD)/git/git-flow-completion/git-flow-completion.bash $(HOME)/.git-flow-completion.bash
