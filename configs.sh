dev_dir=$HOME/dev
profile_config=$HOME/.profile
wezterm_config=$HOME/.wezterm.lua
zellij_config=$HOME/.config/zellij/config.kdl
zellij_layouts=$HOME/.config/zellij/layouts


mkdir -p $(dirname $profile_config)
mkdir -p $(dirname $wezterm_config)
mkdir -p $(dirname $zellij_config)

ln -sf $dev_dir/configs/profile $profile_config
ln -sf $dev_dir/configs/wezterm.lua $wezterm_config
ln -sf $dev_dir/configs/zellij.kdl $zellij_config
ln -sf $dev_dir/layouts $zellij_layouts
