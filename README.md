# Setup

## macOS

    brew install chezmoi
    chezmoi init --apply --source .

## Ubuntu (Online)

    curl -fsLS get.chezmoi.io | sh
    ~/bin/chezmoi init --apply --source ~/xProfile

## Ubuntu (Offline)

On a machine with internet:

    ./scripts/prepare_offline_bundle.sh

Copy `offline-packages/` and `xProfile/` to the target machine, then:

    # Copy bundle to target
    scp -r offline-packages/ user@host:~/.local/share/offline-packages
    scp -r xProfile/ user@host:~/xProfile

    # On the target machine
    chezmoi init --apply --source ~/xProfile

## Docker Verification

    cd docker/ubuntu
    docker compose up -d --build
    docker exec -it dotfiles_ubuntu_verify bash
    ~/bin/chezmoi init --apply --source ~/xProfile

# Reference

https://skwp.github.io/dotfiles/
https://github.com/vinta/HAL-9000
https://www.chezmoi.io/

# Misc

Homebrew 安裝的 git auto completions 會跟 git flow auto completions 衝突：

1. https://github.com/Homebrew/homebrew-core/commit/f710a1395f44224e4bcc3518ee9c13a0dc850be1
2. https://github.com/robbyrussell/oh-my-zsh/issues/1717
3. https://github.com/sorin-ionescu/prezto/issues/993
