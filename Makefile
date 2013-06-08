init:
	git submodule init
	git submodule update
	ln -s $(PWD)/oh-my-zsh $(HOME)/.oh-my-zsh
	ln -s $(PWD)/zshrc $(HOME)/.zshrc
	ln -s $(PWD)/bashrc $(HOME)/.bashrc
	ln -s $(PWD)/aliases $(HOME)/.aliases

git:
	ln -s $(PWD)/git/git-config $(HOME)/.gitconfig
	ln -s $(PWD)/git/git-flow $(HOME)/.git-flow
	ln -s $(PWD)/git/git-flow-completion $(HOME)/.git-flow-completion

ubuntu:
	bash $(PWD)/ubuntu/packages.sh
