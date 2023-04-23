#!/bin/bash

# Variables for the themes
GTK_THEME="WhiteSur-dark"
ICON_THEME="WhiteSur-dark"
SHELL_THEME="WhiteSur-dark"

# Install dependencies
sudo apt-get update
sudo apt-get install -y git gnome-shell-extensions chrome-gnome-shell

# Clone WhiteSur GTK theme repository
if [ ! -d "$HOME/.themes/WhiteSur" ]; then
	git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git "$HOME/WhiteSur-gtk-theme"
	cd "$HOME/WhiteSur-gtk-theme"
	./install.sh -d "$HOME/.themes"
	cd ..
	rm -rf WhiteSur-gtk-theme
fi

# Clone WhiteSur icon theme repository
if [ ! -d "$HOME/.icons/WhiteSur" ]; then
	git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git "$HOME/WhiteSur-icon-theme"
	cd "$HOME/WhiteSur-icon-theme"
	./install.sh -d "$HOME/.icons"
	cd ..
	rm -rf WhiteSur-icon-theme
fi

# Clone WhiteSur GNOME Shell theme repository
if [ ! -d "$HOME/.themes/WhiteSur-shell" ]; then
	git clone https://github.com/vinceliuice/WhiteSur-gnome-shell-theme.git "$HOME/WhiteSur-gnome-shell-theme"
	cd "$HOME/WhiteSur-gnome-shell-theme"
	./install.sh -d "$HOME/.themes"
	cd ..
	rm -rf WhiteSur-gnome-shell-theme
fi

# Apply themes
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
gsettings set org.gnome.shell.extensions.user-theme name "$SHELL_THEME"

echo "WhiteSur-dark theme has been applied."
