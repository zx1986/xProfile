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

fish:
	curl -L https://get.oh-my.fish | fish
	ln -nsiF $(PWD)/fishrc/init.fish $(OMF_CONFIG)/init.fish
	ln -nsiF $(PWD)/fishrc/before.init.fish $(OMF_CONFIG)/before.init.fish
	ln -nsiF $(PWD)/fishrc/key_bindings.fish $(OMF_CONFIG)/key_bindings.fish
