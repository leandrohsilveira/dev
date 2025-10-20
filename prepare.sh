installers=apt

has_apt=$(which apt)
has_brew=$(which brew)

if [ "$has_apt" != "" ]; then
  curl -fsSL https://apt.fury.io/wez/gpg.key | gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
  echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | tee /etc/apt/sources.list.d/wezterm.list
  chmod 644 /usr/share/keyrings/wezterm-fury.gpg

  apt update
  apt install build-essential libreadline-dev unzip zsh fzf wezterm xclip
  exit 0
fi

if [ "$has_brew" != "" ]; then
  # TODO
  echo "brew preparation not implemented yet"
  exit 1

  brew tap wezterm/wezterm-linuxbrew
  brew install wezterm
  exit 0
fi

echo "A package installer is required! (Supported: apt, brew)"

