#!/bin/bash

sudo apt install tmux -y;

echo install nvim;
sudo add-apt-repository ppa:neovim-ppa/unstable;
sudo apt-get update;
sudo apt-get install neovim -y;

echo install neovide
sudo snap install neovide -y;

echo ripgrep
sudo apt-get install ripgrep -y;

echo installing lazygit;
ZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin -y;

echo bat
sudo apt install bat -y;
mkdir -p ~/.local/bin;
ln -s /usr/bin/batcat ~/.local/bin/bat;

echo fdfind
sudo apt install fd-find -y;

echo fzf
t clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install -y;

echo install astroNvim 
sudo mkdir -p ~/.config/nvim 
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak

git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
nvim
echo Pycharm
flatpak install pycharm-professional -y;

echo Webstorm
flatpak install webstorm -y;

echo install discord
flatpak install discordapp -y;


echo install telegram;
sudo apt-get install telegram-desktop -y;
flatpak install todoist  -y;

echo install anki
sudo flatpak install ankiweb -y;

echo zoxide
sudo apt install zoxide -y;
