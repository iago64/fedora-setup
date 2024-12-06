# Update
sudo dnf update

# Paquetes Herramientas
echo "Installando Herramientas Generales"
sudo dnf install vim emacs nano strace openssh curl htop tree wget terminator xclip bless fastfetch net-tools openssh-server


# Lenguajes de Programacion
echo "Installando Lenguajes y Herramientas de Programacion"
sudo dnf install kernel-devel kernel-headers gcc  gcc-c++ gdb  python3  python3-pip java-21-openjdk dotnet-sdk-8.0 CUnit make  cmake 


# DEV Utils
echo "Installando Utilidades de Programacion"
sudo dnf install valgrind  meld 