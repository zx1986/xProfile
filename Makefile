ZSH_FUNC_DIR="/usr/local/share/zsh/site-functions/"
KREW=./krew-"`uname | tr '[:upper:]' '[:lower:]'`_amd64"

.PHONY: init
init: ## 初始化環境配置
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	cp -iv .env.example .env
	ln -nsiF $(PWD)/.env $(HOME)/.env
	ln -nsiF $(PWD)/terraformrc $(HOME)/.terraformrc
	ln -nsiF $(PWD)/editorconfig $(HOME)/.editorconfig
	ln -nsiF $(PWD)/ctags $(HOME)/.ctags
	$(MAKE) git
	$(MAKE) tmux
	$(MAKE) asdf

.PHONY: git
git: ## 配置 Git
	brew install git
	ln -nsiF $(PWD)/gittemplate $(HOME)/.gittemplate
	ln -nsiF $(PWD)/gitignore $(HOME)/.gitignore
	ln -nsiF $(PWD)/gitconfig $(HOME)/.gitconfig

.PHONY: tmux
tmux: ## 配置 tmux
	ln -nsiF $(PWD)/tmux.conf $(HOME)/.tmux.conf
	mkdir -p ~/.tmux/plugins/
	cd ~/.tmux/plugins/ && git clone https://github.com/tmux-plugins/tpm.git
	tmux source-file ~/.tmux.conf

.PHONY: asdf
asdf: ## 配置 asdf
	brew install coreutils curl git asdf
	ln -nsiF $(PWD)/tool-versions $(HOME)/.tool-versions

.PHONY: golang
golang: ## 配置 Golang
	asdf plugin add golang && asdf install golang latest
	curl -L https://github.com/vmware/govmomi/releases/download/v0.29.0/govc_darwin_amd64.gz | gunzip > /usr/local/bin/govc
	chmod +x /usr/local/bin/govc

.PHONY: ruby
ruby: ## 配置 Ruby
	asdf plugin add ruby && asdf install ruby latest
	ln -nsiF $(PWD)/gemrc $(HOME)/.gemrc
	ln -nsiF $(PWD)/rubocop.yml $(HOME)/.rubocop.yml

.PHONY: kube
kube: ## 配置 Kubernetes kubectl
	asdf plugin add kubectl && asdf install kubectl latest
	$(MAKE) krew

.PHONY: krew
krew: ## 配置 Kubernetes kubectl 外掛管理器
	set -x; cd "$(mktemp -d)" && \
	curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.{tar.gz,yaml}" && \
	tar zxvf krew.tar.gz && \
	"$(KREW)" install --manifest=krew.yaml --archive=krew.tar.gz && \
	"$(KREW)" update
	kubectl krew install access-matrix
	kubectl krew install cssh
	kubectl krew install pod-logs
	kubectl krew install pod-shell
	kubectl krew install rbac-lookup
	kubectl krew install rbac-view
	kubectl krew install trace
	kubectl krew install view-secret
	kubectl krew install view-utilization
	kubectl krew install warp

.PHONY: helm
helm: ## 配置 kubernetes helm
	asdf plugin add helm && asdf install helm latest
	helm plugin install https://github.com/technosophos/helm-template
	helm plugin install https://github.com/maorfr/helm-backup
	helm plugin install https://github.com/maorfr/helm-restore
	helm plugin install https://github.com/maorfr/helm-inject
	helm plugin install https://github.com/maorfr/helm-logs
	helm plugin install https://github.com/mstrzele/helm-edit
	helm plugin install https://github.com/adamreese/helm-env
	helm plugin install https://github.com/adamreese/helm-last
	helm plugin install https://github.com/ContainerSolutions/helm-monitor
	helm plugin install https://github.com/databus23/helm-diff
	helm plugin install https://github.com/futuresimple/helm-secrets

.PHONY: antibody
antibody: ## 配置 Zsh - antibody
	touch $(HOME)/.zshrc && rm -iv $(HOME)/.zshrc
	curl -L https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/zsh/_docker -o $(ZSH_FUNC_DIR)/_docker
	curl -L https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/plugins/terraform/_terraform -o $(ZSH_FUNC_DIR)/_terraform
	ln -nsiF $(PWD)/zshrc/zsh_plugins.txt $(HOME)/.zsh_plugins.txt
	ln -nsiF $(PWD)/zshrc/antibody.zshrc $(HOME)/.zshrc
	$(MAKE) xsh

.PHONY: ohmyzsh
ohmyzsh: ## 配置 Zsh - oh-my-zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	touch $(HOME)/.zshrc && rm -iv $(HOME)/.zshrc
	ln -nsiF $(PWD)/zshrc/ohmyzsh.zshrc $(HOME)/.zshrc
	git clone https://github.com/zsh-users/zsh-history-substring-search $(HOME)/.oh-my-zsh/custom/plugins/zsh-history-substring-search
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone https://github.com/supercrabtree/k $(HOME)/.oh-my-zsh/custom/plugins/k
	git clone https://github.com/denysdovhan/spaceship-prompt.git ~/.oh-my-zsh/custom/themes/spaceship-prompt
	ln -s $(HOME)/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme $(HOME)/.oh-my-zsh/custom/themes/spaceship.zsh-theme
	$(MAKE) xsh

.PHONY: zim
zim: ## 配置 Zsh - zim
	rm -rf ~/.zim* ~/.zshrc* ~/.zshenv* ~/.zlogin*
	curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
	echo 'zmodule denysdovhan/spaceship-prompt --name spaceship' >> $(HOME)/.zimrc
	zsh ~/.zim/zimfw.zsh install
	$(MAKE) xsh

.PHONY: xsh
xsh: ## 配置 Shell
	ln -nsiF $(PWD)/aliases $(HOME)/.aliases
	ln -nsiF $(PWD)/zshrc/zsh_pre_setup $(HOME)/.zsh_pre_setup
	ln -nsiF $(PWD)/zshrc/zsh_post_setup $(HOME)/.zsh_post_setup
	(echo '[ -f ~/.zsh_pre_setup ] && source ~/.zsh_pre_setup' && cat $(HOME)/.zshrc) > /tmp/zshrc && mv /tmp/zshrc $(HOME)/.zshrc
	echo '[ -f ~/.zsh_post_setup ] && source ~/.zsh_post_setup' >> $(HOME)/.zshrc
	zsh -l -c "autoload -U +X bashcompinit && bashcompinit"
	zsh -l -c "autoload -U +X compinit && compinit"

.PHONY: iterm
iterm: ## 配置 iTerm
	curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh
	curl -L https://iterm2.com/utilities/imgcat -o /usr/local/bin/imgcat
	curl -L https://iterm2.com/utilities/imgls -o /usr/local/bin/imgls
	chmod a+x /usr/local/bin/*

.PHONY: clean
clean: ## 移除 git 沒有管理的檔案跟目錄
	git clean -f -d

# Absolutely awesome: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
