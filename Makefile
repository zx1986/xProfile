.PHONY: init
init: ## Auto-detect environment and initialize dotfiles via chezmoi
	@echo "Detected OS: $$(uname -s)"
	@if [ "$$(uname -s)" = "Darwin" ]; then \
		echo "Setting up macOS environment..."; \
		if ! command -v brew >/dev/null 2>&1; then \
			echo "Installing Homebrew..."; \
			/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"; \
		fi; \
		echo "Looking for chezmoi..."; \
		if ! command -v chezmoi >/dev/null 2>&1; then \
			echo "Installing chezmoi..."; \
			brew install chezmoi; \
		fi; \
		chezmoi init --apply --source "$(PWD)"; \
	elif [ "$$(uname -s)" = "Linux" ]; then \
		echo "Setting up Linux environment..."; \
		if ! command -v chezmoi >/dev/null 2>&1 && [ ! -f "$(HOME)/bin/chezmoi" ]; then \
			echo "Installing chezmoi..."; \
			curl -fsLS https://get.chezmoi.io | sh; \
		fi; \
		if [ -f "$(HOME)/bin/chezmoi" ]; then \
			"$(HOME)/bin/chezmoi" init --apply --source "$(PWD)"; \
		elif command -v chezmoi >/dev/null 2>&1; then \
			chezmoi init --apply --source "$(PWD)"; \
		else \
			echo "Error: chezmoi not found after install"; exit 1; \
		fi; \
	else \
		echo "Unsupported OS: $$(uname -s)"; exit 1; \
	fi

.PHONY: clean
clean: ## Remove files managed by chezmoi and clean up third-party directories
	@echo "Looking for chezmoi binary..."
	@if command -v chezmoi >/dev/null 2>&1; then \
		CHEZMOI_BIN=$$(command -v chezmoi); \
	elif [ -f "$(HOME)/bin/chezmoi" ]; then \
		CHEZMOI_BIN="$(HOME)/bin/chezmoi"; \
	else \
		echo "chezmoi not installed, nothing to clean."; exit 0; \
	fi; \
	echo "Removing chezmoi managed files in $(HOME)..."; \
	if $$CHEZMOI_BIN source-path >/dev/null 2>&1; then \
		$$CHEZMOI_BIN managed -i files | while read -r file; do \
			target="$(HOME)/$$file"; \
			if [ -f "$$target" ] || [ -L "$$target" ]; then \
				echo "Removing $$target"; \
				rm -f "$$target"; \
			fi; \
		done; \
		$$CHEZMOI_BIN managed -i scripts | while read -r script; do \
			target="$(HOME)/$$script"; \
			if [ -f "$$target" ] || [ -L "$$target" ]; then \
				echo "Removing $$target"; \
				rm -f "$$target"; \
			fi; \
		done; \
	else \
		echo "Chezmoi state not found or initialized."; \
	fi
	@echo "Cleaning up third-party tool directories..."
	rm -rf "$(HOME)/.zprezto" "$(HOME)/.tmux" "$(HOME)/.asdf" "$(HOME)/.local/share/offline-packages"
	@echo "Cleanup completed."

# Absolutely awesome: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
