#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Install surface-kernel
dnf5 config-manager -y \
    addrepo --from-repofile=https://pkg.surfacelinux.com/fedora/linux-surface.repo
dnf5 -y remove --no-autoremove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-tools kernel-tools-libs zram-generator-defaults
# rm -rf /boot/* /usr/lib/modules/* /lib/modules/*
dnf5 -y --setopt=tsflags=noscripts install kernel-surface
dnf5 -y install --allowerasing iptsd libwacom-surface

# Enabling a System Unit Files

systemctl enable podman.socket
