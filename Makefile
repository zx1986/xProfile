KREW=./krew-"`uname | tr '[:upper:]' '[:lower:]'`_amd64"

.PHONY: init
init: ## 初始化環境配置
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	-cp -iv env.example .env
	ln -nsiF $(PWD)/.env $(HOME)/.env
	ln -nsiF $(PWD)/aliases $(HOME)/.aliases
	ln -nsiF $(PWD)/terraformrc $(HOME)/.terraformrc
	ln -nsiF $(PWD)/editorconfig $(HOME)/.editorconfig
	ln -nsiF $(PWD)/ctags $(HOME)/.ctags
	$(MAKE) zsh
	$(MAKE) git
	$(MAKE) tmux
	$(MAKE) asdf

.PHONY: git
git: ## 配置 Git
	brew install git tig bit-git curl
	ln -nsiF $(PWD)/gittemplate $(HOME)/.gittemplate
	ln -nsiF $(PWD)/gitignore $(HOME)/.gitignore
	ln -nsiF $(PWD)/gitconfig $(HOME)/.gitconfig
	bit complete
	-bit

.PHONY: tmux
tmux: ## 配置 tmux
	ln -nsiF $(PWD)/tmux.conf $(HOME)/.tmux.conf
	mkdir -p ~/.tmux/plugins/
	cd ~/.tmux/plugins/ && git clone https://github.com/tmux-plugins/tpm.git
	-tmux source-file ~/.tmux.conf

.PHONY: asdf
asdf: ## 配置 asdf
	brew install asdf
	ln -nsiF $(PWD)/tool-versions $(HOME)/.tool-versions

.PHONY: golang
golang: ## 配置 Golang
	-asdf plugin add golang
	asdf install golang latest
	curl -L https://github.com/vmware/govmomi/releases/download/v0.29.0/govc_Darwin_x86_64.tar.gz | gunzip > /usr/local/bin/govc
	chmod +x /usr/local/bin/govc

.PHONY: ruby
ruby: ## 配置 Ruby
	-asdf plugin add ruby
	asdf install ruby latest
	ln -nsiF $(PWD)/gemrc $(HOME)/.gemrc
	ln -nsiF $(PWD)/rubocop.yml $(HOME)/.rubocop.yml

.PHONY: python
python: ## 配置 Python
	-asdf plugin add python
	asdf install python latest

.PHONY: nodejs
nodejs: ## 配置 NodeJS
	-asdf plugin add nodejs
	asdf install nodejs latest

.PHONY: kube
kube: ## 配置 Kubernetes kubectl
	-asdf plugin add kubectl
	asdf install kubectl latest
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

.PHONY: zsh
zsh: ## 配置 Zsh
	brew install zsh coreutils
	$(PWD)/zshrc/prezto.sh
	ln -nsiF $(PWD)/zshrc/zpreztorc $(HOME)/.zpreztorc

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
