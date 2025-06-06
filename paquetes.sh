set -e

# Update
sudo dnf update

# Paquetes Herramientas
echo "Installando Herramientas Generales"
sudo dnf install -y vim emacs nano strace openssh curl htop tree wget terminator xclip bless fastfetch net-tools openssh-server valgrind meld

# Lenguajes de Programacion
echo "Installando Lenguajes y Herramientas de Programacion"
sudo dnf install -y kernel-devel kernel-headers gcc gcc-c++ gdb python3 python3-pip java-21-openjdk dotnet-sdk-8.0 CUnit make cmake 

# installs nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Avoid restart shell
\. "$HOME/.nvm/nvm.sh"

# download and install Node.js (you may need to restart the terminal)
nvm install 22
node -v
nvm current
corepack enable pnpm
pnpm -v

# Install Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
sudo dnf -y install code

# Add Podman
sudo dnf install -y podman

# ZSH
echo "Installando ZSH"
sudo dnf -y install zsh

# Oh My ZSH
echo "Installando Oh My ZSH --> ZSH Cheto"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"