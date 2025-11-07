set -e

# Update
sudo dnf update -y

# Paquetes Herramientas
sudo dnf install -y vim \
    emacs \
    nano \
    strace \
    openssh \
    curl \
    htop \
    tree \
    wget \
    terminator \
    xclip \
    bless \
    fastfetch \
    net-tools \
    openssh-server \
    valgrind \
    meld

# Lenguajes de Programacion
sudo dnf install -y kernel-devel \
    kernel-headers \
    gcc \
    gcc-c++ \
    gdb \
    python3 \
    python3-pip \
    adoptium-temurin-java-repository \
    temurin-21-jdk \
    dotnet-sdk-8.0 \
    CUnit \
    make \
    cmake 

sudo update-alternatives --config java

# SDKMan
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install quarkus
sdk install gradle
echo "JAVA_HOME=/usr/lib/jvm/temurin-21-jdk" | sudo tee /etc/java/maven.conf

# installs nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Avoid restart shell
\. "$HOME/.nvm/nvm.sh"

# download and install Node.js (you may need to restart the terminal)
nvm install 24
node -v
nvm current
corepack enable pnpm
pnpm -v

# Add Podman
sudo dnf install -y podman \
    podman-compose

systemctl --user enable podman.socket
systemctl --user start podman.socket

# Install Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" \
  | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
sudo dnf -y install code

# Add Flathub
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Flatpaks
flatpak install -y flathub \
    com.discordapp.Discord \
    com.getpostman.Postman \
    com.obsproject.Studio \
    org.libretro.RetroArch \
    com.bitwarden.desktop 

# ZSH
sudo dnf -y install zsh

# Oh My ZSH
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"