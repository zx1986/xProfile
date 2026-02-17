FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    locales \
    zsh \
    tmux \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN useradd -m -s /bin/zsh zx1986 && \
    echo "zx1986 ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER zx1986
WORKDIR /home/zx1986

CMD ["tail", "-f", "/dev/null"]
