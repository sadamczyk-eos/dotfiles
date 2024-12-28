#!/bin/bash

dnf upgrade --refresh -y

test -f /usr/bin/open || ln -s /usr/bin/xdg-open /usr/bin/open

dnf copr enable -y wezfurlong/wezterm-nightly
dnf groupinstall -y 'Development Tools'
dnf install -y \
  pipx \
  wezterm \
  nautilus-python \
  fish \
  syncthing \
  gcc-c++ \
  procps-ng curl file git # brew dependencies https://docs.brew.sh/Homebrew-on-Linux#requirements

# Install Docker-CE
# https://docs.docker.com/engine/install/fedora/
# The sed command fixes extremely slow RPM package installation (yum etc.);
# fixed in the docker images of newer RPM-based distros: https://github.com/rpm-software-management/rpm/commit/5e6f05cd8dad6c1ee6bd1e6e43f176976c9c3416
dnf -y install dnf-plugins-core \
  && dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo \
  && dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
  && usermod -aG docker $SUDO_USER \
  && systemctl enable docker.service \
  && systemctl enable containerd.service \
  && sed -i 's/LimitNOFILE=infinity/LimitNOFILE=1024/' /usr/lib/systemd/system/docker.service

# Enable services
systemctl enable --now syncthing@$SUDO_USER.service
