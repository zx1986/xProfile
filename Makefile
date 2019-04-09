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
	ln -nsiF $(PWD)/alacritty.yml $(HOME)/.config/alacritty/alacritty.yml
	ln -nsiF $(PWD)/kitty.config $(HOME)/.config/kitty/kitty.config
	$(MAKE) zsh
	$(MAKE) tmux

tmux:
	mkdir -p ~/.tmux/plugins/
	cd ~/.tmux/plugins/ && git clone https://github.com/tmux-plugins/tpm.git
	tmux source-file ~/.tmux.conf

kube:
	curl https://raw.githubusercontent.com/weibeld/kubectl-ctx/master/kubectl-ctx -o /usr/local/bin/kubectl-ctx
	curl https://raw.githubusercontent.com/weibeld/kubectl-ns/master/kubectl-ns -o /usr/local/bin/kubectl-ns
	chmod a+x /usr/local/bin/kubectl-*
	set -x; cd "$(mktemp -d)" && \
	curl -fsSLO "https://storage.googleapis.com/krew/v0.2.1/krew.{tar.gz,yaml}" && \
	tar zxvf krew.tar.gz && \
	./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" install \
	--manifest=krew.yaml --archive=krew.tar.gz

ohmyzsh:
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	rm -iv ${HOME}/.zshrc
	ln -nsiF $(PWD)/zshrc/ohmyzsh.zshrc ${HOME}/.zshrc
	git clone https://github.com/zsh-users/zsh-history-substring-search ${HOME}/.oh-my-zsh/custom/plugins/zsh-history-substring-search
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone https://github.com/petervanderdoes/git-flow-completion ${HOME}/.oh-my-zsh/custom/plugins/git-flow-completion
	git clone https://github.com/supercrabtree/k ${HOME}/.oh-my-zsh/custom/plugins/k
	git clone https://github.com/denysdovhan/spaceship-prompt.git ~/.oh-my-zsh/custom/themes/spaceship-prompt
	ln -s ${HOME}/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme ${HOME}/.oh-my-zsh/custom/themes/spaceship.zsh-theme

zsh:
	touch ${HOME}/.zshrc && rm -iv ${HOME}/.zshrc
	ln -nsiF $(PWD)/zshrc/antibody.zshrc ${HOME}/.zshrc

fish:
	curl -L https://get.oh-my.fish | fish
	ln -nsiF $(PWD)/fishrc/init.fish $(OMF_CONFIG)/init.fish
	ln -nsiF $(PWD)/fishrc/before.init.fish $(OMF_CONFIG)/before.init.fish
	ln -nsiF $(PWD)/fishrc/key_bindings.fish $(OMF_CONFIG)/key_bindings.fish
