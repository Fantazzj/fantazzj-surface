#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Install surface-kernel
curl -Lo /etc/yum.repos.d/linux-surface.repo https://pkg.surfacelinux.com/fedora/linux-surface.repo 

#dnf5 -y download --destdir=/tmp/kernel-rpms \
#  kernel-surface \
#  kernel-surface-core \
#  kernel-surface-modules \
#  kernel-surface-modules-core \
#  kernel-surface-modules-extra \
#  kernel-surface-devel-matched \
#  kernel-surface-default-watchdog \
#  kernel-uki-virt \
#  libwacom-surface \
#  libwacom-surface-data \
#  iptsd

#rpm-ostree override replace \
#  --experimental \
#  --remove kernel \
#  --remove kernel-core \
#  --remove kernel-modules \
#  --remove kernel-modules-core \
#  --remove kernel-modules-extra \
#  --remove kernel-devel-matched \
#  --remove libwacom \
#  --remove libwacom-data \
#  /tmp/kernel-rpms/kernel-surface-*.rpm \
#  /tmp/kernel-rpms/libwacom-surface*.rpm \
#  /tmp/kernel-rpms/iptsd*.rpm

dnf5 -y remove kernel*
dnf5 -y install --allowerasing --setopt=tsflags=noscripts \
  kernel-surface \
  kernel-surface-devel \
  iptsd \
  libwacom-surface

KERNEL_SUFFIX="surface"
QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-(|'"$KERNEL_SUFFIX"'-)(\d+\.\d+\.\d+)' | sed -E 's/kernel-(|'"$KERNEL_SUFFIX"'-)//')"
depmod "$QUALIFIED_KERNEL"
/usr/bin/dracut --no-hostonly --kver "$QUALIFIED_KERNEL" --reproducible -v --add ostree -f "/lib/modules/$QUALIFIED_KERNEL/initramfs.img"
chmod 0600 "/lib/modules/$QUALIFIED_KERNEL/initramfs.img"

# Enabling a System Unit Files

systemctl enable podman.socket
