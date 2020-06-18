ZSH_FUNC_DIR="/usr/local/share/zsh/site-functions/"
KREW=./krew-"`uname | tr '[:upper:]' '[:lower:]'`_amd64"

.PHONY: init
init: ## 初始化環境配置
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	-cp -iv .env.example .env
	ln -nsiF $(PWD)/.env $(HOME)/.env
	ln -nsiF $(PWD)/terraformrc $(HOME)/.terraformrc
	ln -nsiF $(PWD)/editorconfig $(HOME)/.editorconfig
	ln -nsiF $(PWD)/ctags $(HOME)/.ctags
	$(MAKE) asdf
	$(MAKE) git
	$(MAKE) go
	$(MAKE) ruby
	$(MAKE) tmux

.PHONY: asdf
asdf: ## 配置 asdf
	brew install coreutils curl git asdf
	ln -nsiF $(PWD)/tool-versions $(HOME)/.tool-versions

.PHONY: git
git: ## 配置 Git
	brew install git
	ln -nsiF $(PWD)/git_template $(HOME)/.git_template
	ln -nsiF $(PWD)/gitignore $(HOME)/.gitignore
	ln -nsiF $(PWD)/gitconfig $(HOME)/.gitconfig

.PHONY: go
go: ## 配置 Golang
	asdf plugin add golang && asdf install golang latest
	curl -L https://github.com/vmware/govmomi/releases/download/v0.23.0/govc_darwin_amd64.gz | gunzip > /usr/local/bin/govc
	chmod +x /usr/local/bin/govc

.PHONY: ruby
ruby: ## 配置 Ruby
	asdf plugin add ruby && asdf install ruby latest
	ln -nsiF $(PWD)/gemrc $(HOME)/.gemrc
	ln -nsiF $(PWD)/rubocop.yml $(HOME)/.rubocop.yml

.PHONY: tmux
tmux: ## 配置 tmux
	ln -nsiF $(PWD)/tmux.conf $(HOME)/.tmux.conf
	ln -nsiF $(PWD)/tmuxinator $(HOME)/.tmuxinator
	mkdir -p ~/.tmux/plugins/
	cd ~/.tmux/plugins/ && git clone https://github.com/tmux-plugins/tpm.git
	tmux source-file ~/.tmux.conf

.PHONY: kube
kube: ## 配置 Kubernetes kubectl
	asdf plugin add kubectl && asdf install kubectl latest
	asdf plugin add kubectx && asdf install kubectx latest
	curl -L https://github.com/aylei/kubectl-debug/releases/download/v0.1.1/kubectl-debug_0.1.1_darwin_amd64.tar.gz -o /tmp/kubectl-debug.tar.gz
	tar -zxvf /tmp/kubectl-debug.tar.gz && mv kubectl-debug /usr/local/bin/kubectl-debug
	curl -L https://github.com/iovisor/kubectl-trace/releases/download/v0.1.0-rc.1/kubectl-trace_0.1.0-rc.1_darwin_amd64.tar.gz -o /tmp/kubectl-trace.tar.gz
	tar -zxvf /tmp/kubectl-trace.tar.gz && mv kubectl-trace /usr/local/bin/kubectl-trace
	chmod a+x /usr/local/bin/kubectl-*
	$(MAKE) krew

.PHONY: krew
krew: ## 配置 Kubernetes kubectl 外掛管理器
	set -x; cd "$(mktemp -d)" && \
	curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.{tar.gz,yaml}" && \
	tar zxvf krew.tar.gz && \
	"$(KREW)" install --manifest=krew.yaml --archive=krew.tar.gz && \
	"$(KREW)" update
	kubectl krew install warp
	kubectl krew install cssh
	kubectl krew install rbac-view
	kubectl krew install rbac-lookup
	kubectl krew install access-matrix
	kubectl krew install pod-logs
	kubectl krew install pod-shell
	kubectl krew install view-secret
	kubectl krew install view-utilization

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
antibody: ## 配置自定義的 antibody zsh 環境
	touch $(HOME)/.zshrc && rm -iv $(HOME)/.zshrc
	curl -L https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/zsh/_docker -o $(ZSH_FUNC_DIR)/_docker
	curl -L https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/plugins/terraform/_terraform -o $(ZSH_FUNC_DIR)/_terraform
	ln -nsiF $(PWD)/zshrc/zsh_plugins.txt $(HOME)/.zsh_plugins.txt
	ln -nsiF $(PWD)/zshrc/antibody.zshrc $(HOME)/.zshrc
	$(MAKE) xsh

.PHONY: ohmyzsh
ohmyzsh: ## 配置 oh-my-zsh
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
zim: ## 配置 zim
	rm -rf ~/.zim* ~/.zshrc* ~/.zshenv* ~/.zlogin*
	curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
	echo 'zmodule romkatv/powerlevel10k' >> $(HOME)/.zimrc
	zsh ~/.zim/zimfw.zsh install
	$(MAKE) xsh

.PHONY: xsh
xsh: ## 配置 Shell
	curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh
	ln -nsiF $(PWD)/aliases $(HOME)/.aliases
	ln -nsiF $(PWD)/zshrc/zx-setup $(HOME)/.zx-setup
	echo '[ -f ~/.zx-setup ] && source ~/.zx-setup' >> $(HOME)/.zshrc
	zsh -l -c "autoload -U +X bashcompinit && bashcompinit"
	zsh -l -c "autoload -U +X compinit && compinit"

.PHONY: clean
clean: ## 移除沒有 git 管理的檔案跟目錄
	git clean -f -d

# Absolutely awesome: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
