#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux

# install surface-kernel
wget -O /etc/yum.repos.d/linux-surface.repo \
    https://pkg.surfacelinux.com/fedora/linux-surface.repo
wget https://github.com/linux-surface/linux-surface/releases/download/silverblue-20201215-1/kernel-20201215-1.x86_64.rpm
rpm-ostree override replace ./*.rpm \
	--remove kernel-core \
	--remove kernel-modules \
	--remove kernel-modules-extra \
        --remove libwacom \
        --remove libwacom-data \
	--install kernel-surface \
	--install iptsd \
        --install libwacom-surface \
        --install libwacom-surface-data


# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
