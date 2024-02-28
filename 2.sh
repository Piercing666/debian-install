#!/bin/bash

# https://github.com/Piercing666

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo su then try again" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

echo "Starting Script 2.sh"


echo "Updating Repositiories"
apt update && upgrade -y
wait

#Installing Priority Programs to setup while this script runs
echo "Installing Priority Programs"
nala install gnome-tweaks -y
nala install nautilus -y
nala install seahorse -y
flatpak install flathub com.mattjakeman.ExtensionManager -y
flatpak install flathub com.google.Chrome -y
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub md.obsidian.Obsidian -y
flatpak install flathub com.dropbox.Client -y
nala install papirus-icon-theme -y
nala install fonts-noto-color-emoji -y
nala install font-manager -y
nala install build-essential -y
nala install unzip -y
nala install linux-headers-generic -y
nala install lua5.4 -y
flatpak install flathub com.visualstudio.code -y

wget "https://global.download.synology.com/download/Utility/SynologyDriveClient/3.4.0-15724/Ubuntu/Installer/synology-drive-client-15724.x86_64.deb"
sudo dpkg -i synology-drive-client-15724.x86_64.deb
wait
rm synology-drive-client-15724.x86_64.deb


echo "Installing Fonts"
# Installing fonts
cd "$builddir" || exit

nala install fonts-font-awesome fonts-noto-color-emoji -y
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d /home/"$username"/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d /home/"$username"/.fonts
mv dotfonts/fontawesome/otfs/*.otf /home/"$username"/.fonts/
chown "$username":"$username" /home/"$username"/.fonts/*

# Reloading Font
fc-cache -vf
wait

# Extensions - will need to be customized still
# After full install dwl Alt+tab and User Themes - versions are not compatible between stable and testing branches.
mkdir -p /home/"$username"/.local/share/gnome-shell/extensions
cp -R dotlocal/share/gnome-shell/extensions/* /home/"$username"/.local/share/gnome-shell/extensions/
chmod -R 777 /home/"$username"/.local/share/gnome-shell/extensions

# Removing zip files and stuff
rm ./FiraCode.zip ./Meslo.zipk
rm -r dotlocal
re -r scripts

# Cursor 
wget -cO- https://github.com/phisch/phinger-cursors/releases/latest/download/phinger-cursors-variants.tar.bz2 | tar xfj - -C ~/.icons

# Install Nordzy cursor
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors || exit
./install.sh
cd "$builddir" || exit
rm -rf Nordzy-cursors

# icons
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'

echo "Installing More Programs"
# Installing other less important but still important Programs, drivers, etc

# Install Steam
wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb
sudo dpkg -i steam.deb
rm steam.deb

nala install gnome-calculator -y
flatpak install flathub org.libreoffice.LibreOffice -y
nala install rename -y
nala install cups -y
nala install util-linux -y
nala install gdebi -y
nala install neofetch -y
nala install gparted -y
nala install gnome-mpv -y
nala install btop -y
nala install curl -y
nala install gh -y
nala install x11-xserver-utils -y
nala install dh-dkms -y
nala install devscripts -y
apt update && upgrade -y
wait
flatpak install https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref -y
flatpak install flathub org.gnome.SimpleScan -y
flatpak install flathub net.scribus.Scribus -y
flatpak install flathub org.blender.Blender -y
flatpak install flathub org.inkscape.Inkscape -y
flatpak install flathub com.flashforge.FlashPrint -y
flatpak install flathub com.obsproject.Studio -y
flatpak install flathub com.usebottles.bottles -y
flatpak install flathub com.github.tchx84.Flatseal -y

apt purge firefox -y
apt purge firefox-esr -y


# dependancy for DaVinci Resolve - have to install manually later, download from website
nala install libfuse2 libglu1-mesa libxcb-composite0 libxcb-cursor0 libxcb-damage0 ocl-icd-libopencl1 libssl-dev ocl-icd-opencl-dev libpango-1.0-0-y
# cp /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0 /opt/resolve/libs
# cd /opt/resolve/libs || exit
# sudo mkdir /opt/resolve/libs/_disabled
# sudo mv libgio* libglib* libgmodule* libgobject* _disabled
# cd /


apt update && upgrade -y
wait
apt full-upgrade -y
wait
apt install -f
wait
dpkg --configure -a
apt install --fix-broken
wait
apt autoremove 
apt update && upgrade -y
wait
flatpak update
wait
reboot




# another way to install vscode and install the extensions listed below
# wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
# install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
# sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
# rm -f packages.microsoft.gpg
# apt install apt-transport-https
# apt update
# wait
# apt install code -y

# If this is your first time using VSCode then create an account and set it up with these extensions. 
# This is a great place to start. This is setup for Lua and Bash, feel free to customize.
# Copy these to a new .sh and run it in terminal - Do not run as sudo.
# code --install-extension DaltonMenezes.aura-theme
# code --install-extension rogalmic.bash-debug
# code --install-extension mads-hartmann.bash-ide-vscode
# code --install-extension CoenraadS.bracket-pair-colorizer
# code --install-extension streetsidesoftware.code-spell-checker
# code --install-extension sourcegraph.cody-ai
# code --install-extension kamikillerto.vscode-colorize
# code --install-extension appulate.filewatcher
# code --install-extension GitHub.vscode-pull-request-github
# code --install-extension eamodio.gitlens
# code --install-extension oderwat.indent-rainbow
# code --install-extension SirTori.indenticator
# code --install-extension ritwickdey.LiveServer
# code --install-extension sumneko.lua
# code --install-extension actboy168.lua-debug
# code --install-extension openra.vscode-openra-lua
# code --install-extension johnpapa.vscode-peacock
# code --install-extension jeanp413.open-remote-ssh
# code --install-extension timonwong.shellcheck
