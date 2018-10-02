init:
	cp -iv .env.sample .env
	ln -nsiF $(PWD)/.env $(HOME)/.env
	ln -nsiF $(PWD)/gemrc $(HOME)/.gemrc
	ln -nsiF $(PWD)/gitignore $(HOME)/.gitignore
	ln -nsiF $(PWD)/gitconfig $(HOME)/.gitconfig
	ln -nsiF $(PWD)/tmux.conf $(HOME)/.tmux.conf
	ln -nsiF $(PWD)/tmuxinator $(HOME)/.tmuxinator
	ln -nsiF $(PWD)/editorconfig $(HOME)/.editorconfig
	ln -nsiF $(PWD)/rubocop.yml $(HOME)/.rubocop.yml
	ln -nsiF $(PWD)/aliases $(HOME)/.aliases
	ln -nsiF $(PWD)/ctags $(HOME)/.ctags
	$(MAKE) zsh
	$(MAKE) tmux

tmux:
	mkdir -p ~/.tmux/plugins/
	cd ~/.tmux/plugins/ && git clone https://github.com/tmux-plugins/tpm.git
	tmux source-file ~/.tmux.conf

zsh:
	git clone --recursive https://github.com/zx1986/prezto.git "$(HOME)/.zprezto"
