#!/bin/bash

dnf upgrade --refresh -y

test -f /usr/bin/open || ln -s /usr/bin/xdg-open /usr/bin/open

# https://www.sublimetext.com/docs/linux_repositories.html#dnf
rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
dnf config-manager addrepo --overwrite --from-repofile=https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

dnf copr enable -y wezfurlong/wezterm-nightly
dnf config-manager setopt google-chrome.enabled=1
dnf group install -y 'development-tools'
dnf install -y \
  dnf-plugins-core \
  python3.12 \
  pipx \
  geary \
  google-chrome-stable \
  wezterm \
  nautilus-python \
  fish \
  easyeffects \
  gcc-c++ \
  sublime-text \
  sublime-merge \
  podman podman-machine \
  procps-ng curl file git # brew dependencies https://docs.brew.sh/Homebrew-on-Linux#requirements

# Install DBeaver
curl -LO https://dbeaver.io/files/dbeaver-ce-latest-stable.x86_64.rpm
dnf install -y dbeaver-ce-latest-stable.x86_64.rpm
rm dbeaver-ce-latest-stable.x86_64.rpm

# Install Docker-CE
# https://docs.docker.com/engine/install/fedora/
# The sed command fixes extremely slow RPM package installation (yum etc.);
# fixed in the docker images of newer RPM-based distros: https://github.com/rpm-software-management/rpm/commit/5e6f05cd8dad6c1ee6bd1e6e43f176976c9c3416
dnf config-manager addrepo --overwrite --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo \
  && dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
  && usermod -aG docker $SUDO_USER \
  && systemctl enable docker.service \
  && systemctl enable containerd.service \
  && sed -i 's/LimitNOFILE=infinity/LimitNOFILE=1024/' /usr/lib/systemd/system/docker.service

# Install Google Cloud CLI
# https://cloud.google.com/sdk/docs/install-sdk?hl=de#rpm
tee /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el8-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM
dnf install -y libxcrypt-compat.x86_64 \
  && dnf install -y google-cloud-cli google-cloud-cli-skaffold google-cloud-cli-gke-gcloud-auth-plugin

# Install Terraform
# https://developer.hashicorp.com/terraform/install#linux
dnf config-manager addrepo --overwrite --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo \
  && dnf -y install terraform
