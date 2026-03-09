#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# --- Update ---
sudo dnf -y update

# --- Herramientas básicas ---
sudo dnf install -y \
    vim emacs nano strace openssh curl htop tree wget terminator \
    xclip bless fastfetch net-tools openssh-server valgrind meld jq

# --- Lenguajes y compiladores ---
sudo dnf install -y \
    kernel-devel kernel-headers gcc gcc-c++ gdb python3 python3-pip \
    adoptium-temurin-java-repository dotnet-sdk-10.0 \
    CUnit make cmake

# --- SDKMAN ---
if [[ ! -d "$HOME/.sdkman" ]]; then
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk install java 21.0.10-amzn
    sdk install java 25.0.2-amzn
    sdk install quarkus
    sdk install gradle
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

# --- JetBrains Toolbox ---
TBA_LINK=$(curl -fsSL "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release" | jq -r '.TBA[0].downloads.linux.link')
wget -qO- "${TBA_LINK:?}" | sudo tar xvzC /opt
/opt/jetbrains-toolbox-*/bin/jetbrains-toolbox

# --- Flatpak + Flathub ---
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y --noninteractive flathub \
    com.discordapp.Discord \
    com.usebruno.Bruno \
    com.obsproject.Studio \
    org.libretro.RetroArch \
    org.videolan.VLC \
    com.bitwarden.desktop || true

# --- ZSH + Oh My Zsh ---
sudo dnf -y install zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --- Integrar configuraciones de entorno en Zsh ---
ZSHRC="$HOME/.zshrc"

{
    echo ""
    echo "# --- Entorno de desarrollo personalizado ---"
    echo "# NVM / Node.js"
    echo 'export NVM_DIR="$HOME/.nvm"'
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'
    echo ""
    echo "# PNPM"
    echo 'export PATH="$HOME/.local/share/pnpm:$PATH"'
    echo ""
    echo "# SDKMAN"
    echo 'export SDKMAN_DIR="$HOME/.sdkman"'
    echo '[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"'
    echo ""
    echo "# Java"
    echo 'export JAVA_HOME="/usr/lib/jvm/temurin-21-jdk"'
    echo 'export PATH="$JAVA_HOME/bin:$PATH"'
    echo ""
} >> "$ZSHRC"