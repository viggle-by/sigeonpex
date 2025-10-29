FROM archlinux:base-devel AS common

RUN pacman-key --init && pacman-key --populate archlinux

WORKDIR /tmp/work
COPY . .

# So that our mirrorlist gets used instead
RUN rm /etc/pacman.d/mirrorlist

# Concat our files to their corresponding files in /
RUN ./scripts/concat-root.sh /tmp/work/root

# Remove some headless container oriented options from pacman.conf
RUN sed -i '/NoExtract/d' /etc/pacman.conf
RUN sed -i '/NoProgressBar/d' /etc/pacman.conf

RUN ./scripts/install-packages.sh

# Remove the pacman keys as per the Arch Linux security guide
# https://gitlab.archlinux.org/archlinux/archlinux-docker/blob/master/README.md#principles
RUN rm -rf \
    ./etc/pacman.d/gnupg/openpgp-revocs.d/* \
    ./etc/pacman.d/gnupg/private-keys-v1.d/* \
    ./etc/pacman.d/gnupg/pubring.gpg~ \
    ./etc/pacman.d/gnupg/S.*
