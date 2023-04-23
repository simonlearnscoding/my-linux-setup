#!/bin/bash
%TODO create an ssh key
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
YELLOW='\033[1;33m'

%TODO: htop, plover, gitkraken
CWD=$(pwd)

delay_after_message=3

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with sudo (sudo -i)"
	exit 1
fi

read -p "Please enter your username: " target_user

if id -u "$target_user" >/dev/null 2>&1; then
	echo "User $target_user exists! Proceeding.. "
else
	echo 'The username you entered does not seem to exist.'
	exit 1
fi

# function to run command as non-root user
run_as_user() {
	sudo -u $target_user bash -c "$1"
}

# run_as_user "touch test.txt"

SSH_KEYS=./dot.ssh.zip
if [ -f "$SSH_KEYS" ]; then
	printf "${YELLOW}Installing SSH Keys${NC}\n"
	sleep $delay_after_message
	run_as_user "rm -rf /home/ibnyusrat/.ssh"
	run_as_user "touch /home/${target_user}/.zshrc"
	run_as_user "unzip ${SSH_KEYS} -d /home/${target_user}/"
	apt install sshuttle -y
	run_as_user "echo 'sshuttle_vpn() {' >> /home/${target_user}/.zshrc"
	run_as_user "echo '	remoteUsername='user';' >> /home/${target_user}/.zshrc"
	run_as_user "echo '	remoteHostname='hostname.com';' >> /home/${target_user}/.zshrc"
	run_as_user "echo '	sshuttle --dns --verbose --remote \$remoteUsername@\$remoteHostname --exclude \$remoteHostname 0/0' >> /home/${target_user}/.zshrc"
	run_as_user "echo '}' >> /home/${target_user}/.zshrc"
else
	printf "${RED}Zip file containing SSH Keys (dot.ssh.zip) was not found in the script directory, therefore keys were not installed ${NC}\n"
	sleep 10
fi

REQUIRED_PKG="flatpak"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG | grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
	printf "${YELLOW}Flatpak is not installed. Installing..${NC}\n"
	sleep $delay_after_message
	apt update -y
	apt install flatpak -y
	apt install gnome-software-plugin-flatpak -y
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	printf "${GREEN}flatpak was installed, but requires a restart. ${NC}\nPlease reboot your computer and run this script again to proceed.\n"
	exit 1
fi

apt update

#Install Z Shell
printf "${YELLOW}Installing ZSH (Shell)${NC}\n"
sleep $delay_after_message
apt install zsh -y
sleep 2
chsh -s /bin/zsh

#Setting up Powerline
# printf "${YELLOW}Installing and Setting up Powerline and Powerline Fonts${NC}\n";
# apt-get install powerline -y
# run_as_user "mkdir -p /home/${target_user}/.fonts";
# run_as_user "cp powerline-fonts/* /home/${target_user}/.fonts/";
#
# run_as_user "git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git /home/${target_user}/.oh-my-zsh";
# run_as_user "cat /home/${target_user}/.oh-my-zsh/templates/zshrc.zsh-template >> /home/${target_user}/.zshrc";
# run_as_user "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/${target_user}/.oh-my-zsh/custom/themes/powerlevel10k";
# run_as_user "sed -i 's/robbyrussell/powerlevel10k\/powerlevel10k/' /home/${target_user}/.zshrc";
# run_as_user "echo 'bindkey -v' >> /home/${target_user}/.zshrc";
#
SYNERGY_DEB=./synergy_1.11.0.rc2_amd64.deb
if [ -f "$SYNERGY_DEB" ]; then
	printf "${YELLOW}Installing Synergy${NC}\n"
	sleep $delay_after_message
	dpkg -i ./$SYNERGY_DEB
	apt-get install -fy
fi

# Remove thunderbird
printf "${RED}Removing thunderbird completely${NC}\n"
sleep $delay_after_message
apt-get purge thunderbird* -y

# Some basic shell utlities
printf "${YELLOW}Installing git, curl and nfs-common.. ${NC}\n"
sleep $delay_after_message
apt install git -y
apt install curl -y
apt install nfs-common -y
apt install preload -y

# printf "${YELLOW}Installing stacer.. ${NC}\n";
# sleep $delay_after_message;
# apt install stacer -y

# Enable Nautilus type-head (instead of search):
printf "${YELLOW}Enabling nautilus typeahead${NC}\n"
sleep $delay_after_message
add-apt-repository ppa:lubomir-brindza/nautilus-typeahead -y

#Install Node Version Manager
printf "${YELLOW}Installing Node Version Manager${NC}\n"
sleep $delay_after_message
run_as_user "wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | zsh"

printf "${YELLOW}Installing Latest LTS Version of NodeJS${NC}\n"
sleep $delay_after_message
run_as_user "source /home/${target_user}/.zshrc && nvm install --lts"

#Install zerotier-cli
# printf "${YELLOW}Installing zerotier-cli${NC}\n";
# sleep $delay_after_message;
# curl -s https://install.zerotier.com | zsh

#Install VIM
# printf "${YELLOW}Installing VIM${NC}\n";
# sleep $delay_after_message;
# apt install vim -y

#Install z.lua
# printf "${YELLOW}Setting up z.lua${NC}\n";
# sleep $delay_after_message;
# apt install lua5.1 -y
# run_as_user "mkdir ~/scripts && cd ~/scripts";
# run_as_user "git clone --depth=1 https://github.com/skywind3000/z.lua";
# run_as_user "mv z.lua /home/${target_user}/.z-lua";
# run_as_user "eval '\$(lua /home/${target_user}/.z-lua/z.lua --init zsh)' >> /home/${target_user}/.zshrc";

#Install Pop OS Splash Screen
printf "${YELLOW}Setting up PopOS Splash Screen${NC}\n"
sleep $delay_after_message
apt install plymouth-theme-pop-logo
update-alternatives --set default.plymouth /usr/share/plymouth/themes/pop-logo/pop-logo.plymouth
kernelstub -a splash
kernelstub -v

#Install GIMP
printf "${YELLOW}Installing GIMP${NC}\n"
sleep $delay_after_message
apt install gimp -y
# Gnome tweak tool
printf "${YELLOW}Installing gnome-tweak-tool${NC}\n"
sleep $delay_after_message
apt install gnome-tweaks -y

#Docker
# printf "${YELLOW}Installing Docker ${NC}\n";
# sleep $delay_after_message;
# apt install docker.io -y
# systemctl enable --now docker
# usermod -aG docker $target_user;

#Install Open-SSH Server
printf "${YELLOW}Installing OpenSSH Server ${NC}\n"
sleep $delay_after_message
apt install openssh-server -y
systemctl enable ssh
systemctl start ssh

#Install Chromium
printf "${YELLOW}Installing chromium-browser${NC}\n"
sleep $delay_after_message
apt install chromium-browser -y

printf "${YELLOW}Install prerequisits for Gnome Shell Extentions${NC}\n"
sleep $delay_after_message
apt install gnome-shell-extensions -y
apt install chrome-gnome-shell -y

echo install nvim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim -y

echo installing neovide

sudo apt install -y curl \
	gnupg ca-certificates git \
	gcc-multilib g++-multilib cmake libssl-dev pkg-config \
	libfreetype6-dev libasound2-dev libexpat1-dev libxcb-composite0-dev \
	libbz2-dev libsndio-dev freeglut3-dev libxmu-dev libxi-dev libfontconfig1-dev \
	libxcursor-dev

curl --proto '=https' --tlsv1.2 -sSf "https://sh.rustup.rs" | sh

cargo install --git https://github.com/neovide/neovide

echo install discord
flatpak install discordapp -y

echo install telegram
sudo apt-get install telegram-desktop -y
flatpak install todoist -y

echo install anki
sudo flatpak install ankiweb -y

echo ripgrep
sudo apt-get install ripgrep -y

echo installing lazygit
ZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin -y

echo bat
sudo apt install bat -y
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat

echo fdfind
sudo apt install fd-find -y

echo fzf
t clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install -y

echo prerequisites for themes installs
sudo apt install \
	git make autoconf automake meson ninja-build pkg-config parallel ruby-sass sassc optipng \
	inkscape \
	libgtk-3-dev libgdk-pixbuf2.0-dev libglib2.0-dev libglib2.0-bin \
	libxml2-utils librsvg2-dev \
	gnome-themes-standard gtk2-engines-murrine gtk2-engines-pixbuf libcanberra-gtk3-module
# TODO: material design
#
fonts-roboto-hinted fonts-noto-hinted
# Some older operating systems don't have sass, in which case you can manually install:
# sudo apt install ruby ruby-bundler ruby-dev
# gem install --user-install sass

# Note: some operating systems come with the Numix theme pre-installed.
# We will remove it to avoid conflict with our more up-to-date version.
sudo apt remove numix-gtk-theme

echo zoxide
sudo apt install zoxide -y
apt dist-upgrade -y
chsh -s /bin/zsh
update-initramfs -u

if command -v curl >/dev/null 2>&1; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
else
	sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
fi

%TODO: put my config on github and download it
echo get neovim folders
git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
git clone https://github.com/luxus/AstroNvim_user ~/.config/astronvim

% TEADMVIEWER
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
sudo dpkg --configure -a
sudo apt install ./teamviewer_amd64.deb -y

sudo flatpak install spotify -y
