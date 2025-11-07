#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# --- Update ---
sudo dnf -y update

# --- Herramientas básicas ---
sudo dnf install -y \
    vim emacs nano strace openssh curl htop tree wget terminator \
    xclip bless fastfetch net-tools openssh-server valgrind meld

# --- Lenguajes y compiladores ---
sudo dnf install -y \
    kernel-devel kernel-headers gcc gcc-c++ gdb python3 python3-pip \
    adoptium-temurin-java-repository temurin-21-jdk \
    dotnet-sdk-8.0 CUnit make cmake

# Configurar Java (solo si hay más de una versión)
if [[ $(update-alternatives --list java | wc -l) -gt 1 ]]; then
    sudo update-alternatives --config java
fi

# --- SDKMAN ---
if [[ ! -d "$HOME/.sdkman" ]]; then
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk install quarkus
    sdk install gradle
fi

# Configurar JAVA_HOME global (si no existe)
JAVA_CONF="/etc/java/maven.conf"
if ! grep -q "JAVA_HOME" "$JAVA_CONF" 2>/dev/null; then
    echo "JAVA_HOME=/usr/lib/jvm/temurin-21-jdk" | sudo tee "$JAVA_CONF" >/dev/null
fi

# --- NVM / Node.js / PNPM ---
if [[ ! -d "$HOME/.nvm" ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    source "$HOME/.nvm/nvm.sh"
fi

source "$HOME/.nvm/nvm.sh"
nvm install 24
nvm alias default 24
corepack enable pnpm

# --- Podman ---
sudo dnf install -y podman podman-compose
systemctl --user enable --now podman.socket

# --- Visual Studio Code ---
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
cat <<EOF | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
sudo dnf -y install code

# --- Flatpak + Flathub ---
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y --noninteractive flathub \
    com.discordapp.Discord \
    com.getpostman.Postman \
    com.obsproject.Studio \
    org.libretro.RetroArch \
    com.bitwarden.desktop || true

# --- ZSH + Oh My Zsh ---
sudo dnf -y install zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
