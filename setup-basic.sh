#!/bin/bash
set -e

# Update system packages
sudo dnf update -y && sudo dnf upgrade -y
# Install kernel modules and development tools
sudo dnf install -y kernel-modules-extra git wget

if [[ -n "${WSL_DISTRO_NAME:-}" ]] || grep -qi microsoft /proc/version; then
    echo "Skipping Microsoft VS Code installation in WSL."
else
    # Install Microsoft VS Code
    # Add official rpm repository (published by Microsoft)
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

    # Install using dnf directly
    sudo dnf install -y code
fi

# Install pyenv
# Install dependencies for pyenv
sudo dnf install -y gcc make patch zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel
# Install pyenv using curl
curl https://pyenv.run | bash
~/.pyenv/bin/pyenv init --install
exec "$SHELL"


# Install Docker Engine
# Install pre-requisites before install docker engine
# sudo dnf install -y dnf-plugins-core
# # Add official rpm repository
# sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

# # Install necessary docker packages
# sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# # Enable and start docker service
# sudo systemctl enable docker.service
# sudo systemctl enable containerd.service
# sudo systemctl start docker
# # Run docker as non-privileged user
# sudo usermod -aG docker $USER
# # Reboot to apply changes
# sudo reboot