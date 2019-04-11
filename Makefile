ZSH_FUNC_DIR="/usr/local/share/zsh/site-functions/"

init:
	cp -iv .env.sample .env
	ln -nsiF $(PWD)/.env $(HOME)/.env
	ln -nsiF $(PWD)/gemrc $(HOME)/.gemrc
	ln -nsiF $(PWD)/terraformrc $(HOME)/.terraformrc
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

krew:
	set -x; cd "$(mktemp -d)" && \
	curl -fsSLO "https://storage.googleapis.com/krew/v0.2.1/krew.{tar.gz,yaml}" && \
	tar zxvf krew.tar.gz && \
	./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" install \
	--manifest=krew.yaml --archive=krew.tar.gz

kube:
	go get -u github.com/iovisor/kubectl-trace/cmd/kubectl-trace
	curl https://raw.githubusercontent.com/weibeld/kubectl-ctx/master/kubectl-ctx -o /usr/local/bin/kubectl-ctx
	curl https://raw.githubusercontent.com/weibeld/kubectl-ns/master/kubectl-ns -o /usr/local/bin/kubectl-ns
	curl https://github.com/aylei/kubectl-debug/releases/download/0.0.2/kubectl-debug_0.0.2_macos-amd64 -o /usr/local/bin/kubectl-debug
	curl https://github.com/guessi/kubectl-search/releases/download/v1.0.3/kubectl-search-`uname -s`-`uname -m` -o /usr/local/bin/kubectl-search
	chmod a+x /usr/local/bin/kubectl-*
	$(MAKE) krew
	kubectl krew install warp
	kubectl krew install cssh
	kubectl krew install rbac-view
	kubectl krew install rbac-lookup
	kubectl krew install pod-logs
	kubectl krew install pod-shell
	kubectl krew install view-secret
	kubectl krew install view-utilization

ohmyzsh:
	$(MAKE) zsh
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
	curl -L https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/zsh/_docker > ${ZSH_FUNC_DIR}/_docker
	curl -L https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/plugins/terraform/_terraform > ${ZSH_FUNC_DIR}/_terraform
	ln -nsiF $(PWD)/zshrc/antibody.zshrc ${HOME}/.zshrc
	ln -nsiF $(PWD)/zshrc/z-pre-setup $(HOME)/.z-pre-setup
	ln -nsiF $(PWD)/zshrc/z-post-setup $(HOME)/.z-post-setup
	zsh -l -c "autoload -U +X bashcompinit && bashcompinit"
	zsh -l -c "autoload -U +X compinit && compinit"

fish:
	curl -L https://get.oh-my.fish | fish
	ln -nsiF $(PWD)/fishrc/init.fish $(OMF_CONFIG)/init.fish
	ln -nsiF $(PWD)/fishrc/before.init.fish $(OMF_CONFIG)/before.init.fish
	ln -nsiF $(PWD)/fishrc/key_bindings.fish $(OMF_CONFIG)/key_bindings.fish
