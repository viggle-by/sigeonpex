#!/bin/bash

set -xe

packages=(
    'git' 'openssh' 'sudo'
    'grml-zsh-config' 'zsh' 'zsh-completions'
    'vim' # todo: replace with 'neovim-symlinks'

    # needed for Sphinx documentation, used in ECM and others
    'glibc-locales'
    # pulls in zsh
    'grml-zsh-config'

    'ripgrep' 'fd' 'fzf' 'jq' 'ninja' 'cmake'
    
    # useful
    'tmux' 'wget' 'curl'

    kde-builder-git

    # All the built packages packages in KDE Linux
    $(pacman --sync --list --quiet kde-linux)

    paru-bin
    visual-studio-code-bin

    # Install the base packages so that we get their docs/auto-completions
    docker
    docker-compose
    podman
)

# Install any updates since the base image was created
pacman --sync --refresh --noconfirm --sysupgrade
pacman --sync --noconfirm "${packages[@]}"

# Post install setup

# Use the host version of docker/podman
HOST_APPS=(docker podman docker-compose xdg-open)
for app in "${HOST_APPS[@]}"; do
    ln -s /usr/bin/distrobox-host-exec /usr/local/bin/$app
done

# Symlink the docker socket to the host
ln -s /run/host/run/docker.sock /run/docker.sock

# mask their systemd services so they don't start
UNITS=(docker.service docker.socket containerd.service podman.service podman.socket)
for unit in "${UNITS[@]}"; do
    systemctl mask $unit
done
