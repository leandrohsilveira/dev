dev_dir=$(pwd)
wezterm_config=$HOME/.wezterm.lua
zellij_config=$HOME/.config/zellij/config.kdl
zellij_layouts=$HOME/.config/zellij/layouts

echo "Syncing configurations..."

mkdir -p $(dirname $wezterm_config)
mkdir -p $(dirname $zellij_config)

./utils/symlink create $dev_dir/configs/wezterm.lua $wezterm_config
./utils/symlink create $dev_dir/configs/zellij.kdl $zellij_config
./utils/symlink create $dev_dir/layouts $zellij_layouts

echo ""
