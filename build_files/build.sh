#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Install surface-kernel
dnf5 config-manager -y \
    addrepo --from-repofile=https://pkg.surfacelinux.com/fedora/linux-surface.repo
dnf5 -y remove --no-autoremove \
       	kernel-core \
       	kernel-modules \
	kernel-modules-extra \

wget https://github.com/linux-surface/linux-surface/releases/download/silverblue-20201215-1/kernel-20201215-1.x86_64.rpm
dnf5 -y install --setopt=tsflags=noscripts ./*.rpm

dnf5 -y install --setopt=tsflags=noscripts kernel-surface
dnf5 -y install --allowerasing iptsd libwacom-surface libwacom-surface-data

# Enabling a System Unit Files

systemctl enable podman.socket
