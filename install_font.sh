#!/bin/bash

# Update package index
sudo apt-get update

# Install necessary packages
sudo apt-get install -y wget unzip fontconfig dconf-cli

# Create the fonts directory if it doesn't exist
mkdir -p ~/.local/share/fonts

# Download and extract FuraMono Nerd Font
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraMono.zip -O /tmp/FiraMono.zip
unzip /tmp/FiraMono.zip -d ~/.local/share/fonts/FiraMonoNerdFont

# Update font cache
fc-cache -fv

# Set FuraMono Nerd Font Mono as the default terminal font
PROFILE_ID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${PROFILE_ID}/ font 'FuraMono Nerd Font Mono 12'
# Clean up
rm /tmp/FiraMono.zip

echo "FuraMono Nerd Font Mono has been installed and set as the default terminal font."
