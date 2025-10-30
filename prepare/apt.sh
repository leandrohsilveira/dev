has_apt=$(which apt)

[ "$has_apt" = "" ] && echo "apt package manager is required" && exit 1

# WezTerm keyrings and sources
curl -fsSL https://apt.fury.io/wez/gpg.key | gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | tee /etc/apt/sources.list.d/wezterm.list
chmod 644 /usr/share/keyrings/wezterm-fury.gpg

# Apt Update
apt update

# Install packages
apt install build-essential libreadline-dev unzip zsh fzf wezterm xclip

