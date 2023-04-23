sudo apt-get install dconf-cli uuid-runtime

# clone the repo into "$HOME/src/gogh"
mkdir -p "$HOME/src"
cd "$HOME/src"
git clone https://github.com/Gogh-Co/Gogh.git gogh
cd gogh

# necessary in the Gnome terminal on ubuntu
export TERMINAL=gnome-terminal

# Enter theme installs dir
cd installs
# install themes
./everforest-dark.sh
./foxnightly.sh
./synthwave.sh
./tokyo-night.sh
./catppuccin-mocha.sh
./dracula.sh
