# syntax=docker/dockerfile:latest
FROM ubuntu:22.04

ARG USERNAME
ARG GROUPNAME
ARG UID
ARG GID

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

RUN apt-get update -y && \
    apt-get install -y --assume-yes --no-install-recommends \
    git \
    curl \
    unzip \
    ca-certificates \
    openssh-server \
    sudo \
    locales \
    tzdata \
    language-pack-ja \
    vim \
    less \
    zsh \
    tig \
    bat \
    ripgrep \
    nodejs \
    npm && \
    locale-gen 'en_US.UTF-8' && \
    locale-gen 'ja_JP.UTF-8' && \
    rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/Etc/GMT+9 /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    echo "TZ=Asia/Tokyo" >> /etc/environment && \
    curl -L 'https://github.com/neovim/neovim/releases/download/v0.10.2/nvim-linux64.tar.gz' | tar zx -C /usr/local && \
    cd /usr/local/bin && ln -sf ../nvim-linux64/bin/nvim nvim && \
    npm install -g n && \
    n lts

RUN apt-get install -y --assume-yes --no-install-recommends \
    build-essential \
    ruby \
    zlib1g-dev \
    qtbase5-dev \
    libavcodec-dev \
    libavdevice-dev \
    libavfilter-dev \
    libswscale-dev \
    libavcodec-extra \
    libzstd-dev \
    liblzma-dev \
    fakeroot \
    bear

RUN apt-get purge -y nodejs npm && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN ssh-keygen -A && \
    mkdir -p /run/sshd && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config

RUN --mount=type=secret,id=PASSWORD export PASSWORD="$(cat /run/secrets/PASSWORD)" && \
    groupadd -g $GID $GROUPNAME && \
    useradd -m -u $UID -g $GID -G sudo $USERNAME && \
    chsh $USERNAME -s /usr/bin/zsh \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    echo "$USERNAME    ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USERNAME

RUN --mount=type=ssh,uid=$UID,gid=$GID mkdir -p -m 0700 ~/.ssh && \
    ssh-keyscan github.com > ~/.ssh/known_hosts 

RUN git clone https://github.com/skipbit/dots.git /home/$USERNAME/dots && \
    make -C /home/$USERNAME/dots install && \
    git clone https://github.com/junegunn/fzf.git /home/$USERNAME/.fzf && \
    /home/$USERNAME/.fzf/install --all --no-bash --no-fish --key-bindings --completion --no-update-rc

RUN nvim --headless "+Lazy! sync" "+qa" && \
    nvim --headless -c "TSUpdate" "+qa"

EXPOSE 22
CMD ["service", "ssh", "start"]

WORKDIR /home/$USERNAME
