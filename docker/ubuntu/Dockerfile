FROM ubuntu:22.04

ARG USERNAME=testuser
ARG USER_UID=1000
ARG USER_GID=1000

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Install all dependencies via apt (while we still have internet/network)
# This is the "online pre-requisite" layer — a real offline machine would
# have these installed by the sysadmin or via the offline .deb bundle.
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Shell & terminal essentials
    zsh \
    tmux \
    git \
    curl \
    wget \
    sudo \
    unzip \
    ca-certificates \
    locales \
    # Build tools (for asdf plugins, compiling from source)
    build-essential \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libbz2-dev \
    libsqlite3-dev \
    libffi-dev \
    liblzma-dev \
    # Useful CLI tools available in Ubuntu 22.04 repos
    fzf \
    fd-find \
    bat \
    tig \
    # For solarized-man and mysql-colorize
    man-db \
    # Network tools (for verification scripts)
    iputils-ping \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \
    # fd is installed as fdfind on Ubuntu; create a symlink
    && ln -sf /usr/bin/fdfind /usr/local/bin/fd \
    # bat is installed as batcat; create symlink
    && ln -sf /usr/bin/batcat /usr/local/bin/bat \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/zsh $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

# Install chezmoi (as the user)
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/bin"

CMD ["sleep", "infinity"]
