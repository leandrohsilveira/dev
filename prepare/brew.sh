has_brew=$(which brew)

[ "$has_brew" = "" ] && echo "brew package manager is required" && exit 1

# build-essential 
xcode-select --install

brew install fzf readline

brew install --cask wezterm
