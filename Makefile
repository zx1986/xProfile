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
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	git clone https://github.com/denysdovhan/spaceship-prompt.git "${ZSH_CUSTOM}/themes/spaceship-prompt"
	ln -s "${ZSH_CUSTOM}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM}/themes/spaceship.zsh-theme"
	git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	git clone https://github.com/petervanderdoes/git-flow-completion ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/git-flow-completion
	git clone https://github.com/supercrabtree/k ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/k
	rm -iv ${HOME}/.zshrc
	ln -nsiF $(PWD)/zshrc/ohmyzsh.zshrc ${HOME}/.zshrc

fish:
	curl -L https://get.oh-my.fish | fish
	ln -nsiF $(PWD)/fishrc/init.fish $(OMF_CONFIG)/init.fish
	ln -nsiF $(PWD)/fishrc/before.init.fish $(OMF_CONFIG)/before.init.fish
	ln -nsiF $(PWD)/fishrc/key_bindings.fish $(OMF_CONFIG)/key_bindings.fish
