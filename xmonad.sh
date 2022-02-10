# Update
sudo dnf update

# Xmonad
echo "Installando xmonad y extras"
sudo dnf install xmonad ghc-xmonad-contrib dmenu xterm redhat-rpm-config ghc

# Xmobar
echo "Installando xmobar --> Barra superior con stats"
sudo dnf install xmobar
mkdir ~/.config/xmobar
cp /usr/share/doc/xmobar/examples/xmobar.config ~/.config/xmobar/xmobarrc
curl https://archives.haskell.org/code.haskell.org/xmonad/man/xmonad.hs > ~/.xmonad/xmonad.hs
