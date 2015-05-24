init:
	ln -nsiF $(PWD)/gemrc $(HOME)/.gemrc
	ln -nsiF $(PWD)/gitignore $(HOME)/.gitignore
	ln -nsiF $(PWD)/gitconfig $(HOME)/.gitconfig
	ln -nsiF $(PWD)/tmux.conf $(HOME)/.tmux.conf
	ln -nsiF $(PWD)/tmuxinator $(HOME)/.tmuxinator
	ln -nsiF $(PWD)/editorconfig $(HOME)/.editorconfig
	ln -nsiF $(PWD)/aliases $(HOME)/.aliases
	echo 'source ~/.aliases' >> ~/.bashrc
	echo 'source ~/.aliases' >> ~/.zshrc
	$(MAKE) tmux
	$(MAKE) rbenv

tmux:
	mkdir -p ~/.tmux/plugins/
	cd ~/.tmux/plugins/ && git clone https://github.com/tmux-plugins/tpm.git
	tmux source-file ~/.tmux.conf

rbenv:
	echo 'eval "$$(rbenv init -)"' >> ~/.bashrc
	echo 'eval "$$(rbenv init -)"' >> ~/.zshrc
