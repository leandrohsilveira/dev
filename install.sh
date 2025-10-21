# Platform
platform=linux
zellij_platform=unknown-linux-musl # or apple-darwin
arch=amd64
arch_bits=x86_64
arch_bits_compact=x64

# NeoVim
neovim_config_repo=git@github.com:leandrohsilveira/nvim-config.git

# Font
font_filename=FiraCode
font_namespace=${font_filename}NerdFont
font_variant=Regular
font_extension=ttf
font_file=${font_namespace}-${font_variant}.${font_extension}

# Folders
sources_folder="./.sources"
downloads_folder="./.downloads"
tools_folder="$HOME/tools"
apps_folder="$HOME/apps"
fonts_folder="$HOME/fonts"
scripts_folder="$HOME/dev/scripts"
bin_folder="$HOME/.local/bin"
installed_fonts_folder=$HOME/.local/share/fonts
neovim_config_folder=$HOME/.config/nvim

# Packages versions
lua_version=5.1.5
luarocks_version=3.12.2
lazygit_version=0.55.1
nodejs_version=v22.20.0
neovim_version=v0.11.4
nerdfont_version=v3.4.0
zellij_version=0.43.1

# Packages File Base Names
lua_filename=lua-$lua_version
luarocks_filename=luarocks-$luarocks_version
lazygit_filename=lazygit_${lazygit_version}_${platform}_${arch_bits}
nodejs_filename=node-$nodejs_version-$platform-$arch_bits_compact
neovim_filename=nvim-$platform-$arch_bits
nerdfont_filename=$font_filename
zellij_filename=zellij-no-web-$arch_bits-$zellij_platform

# Packages File Names
lua_file=$lua_filename.tar.gz
luarocks_file=$luarocks_filename.tar.gz
lazygit_file=$lazygit_filename.tar.gz
nodejs_file=$nodejs_filename.tar.xz
neovim_file=$neovim_filename.tar.gz
nerdfont_file=$nerdfont_filename.tar.xz
zellij_file=$zellij_filename.tar.gz

# Packages URLs
lua_url=https://www.lua.org/ftp/$lua_file
luarocks_url=https://luarocks.github.io/luarocks/releases/$luarocks_file
lazygit_url=https://github.com/jesseduffield/lazygit/releases/download/v$lazygit_version/$lazygit_file
nodejs_url=https://nodejs.org/dist/$nodejs_version/$nodejs_file
neovim_url=https://github.com/neovim/neovim/releases/download/$neovim_version/$neovim_file
nerdfont_url=https://github.com/ryanoasis/nerd-fonts/releases/download/$nerdfont_version/$nerdfont_file
zellij_url=https://github.com/zellij-org/zellij/releases/download/v$zellij_version/$zellij_file

# initializing directories
mkdir -p $sources_folder
mkdir -p $downloads_folder
mkdir -p $apps_folder
mkdir -p $tools_folder
mkdir -p $fonts_folder
mkdir -p $bin_folder

# finding binaries
lua_bin=$(which lua)
luarocks_bin=$(which luarocks)
lazygit_bin=$(which lazygit)
nodejs_bin=$(which node)
neovim_bin=$(which nvim)
zellij_bin=$(which zellij)

# ============================================================================================
# Oh my z.sh
# ============================================================================================

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo ""

# ============================================================================================
# Lua
# ============================================================================================

echo "Checking Lua installation..."

if [ "$lua_bin" = "" ]; then
  echo "Lua is not installed, installing..."
  lua_install="true"
else
  lua_current=$(lua -v 2>&1 | sed "s|Lua ||" | sed "s| Copyright.*||g" | sed "s| ||g")
  echo "Lua is already installed. [current=$lua_current; target=$lua_version]"
  if [ "$lua_version" != "$lua_current" ]; then
    echo "Lua version mismatch, replacing installation..."
    rm -r $tools_folder/lua $bin_folder/lua
    lua_install="true"
  fi
fi

if [ "$lua_install" != "" ]; then
  rm -Rf $downloads_folder/$lua_file

  echo "Downloading Lua from $lua_url"
  curl -L --output $downloads_folder/$lua_file $lua_url

  rm -Rf $sources_folder/$lua_filename
  tar -xzf $downloads_folder/$lua_file -C $sources_folder

  bash -c "cd $sources_folder/$lua_filename && make $platform all test install INSTALL_TOP=$tools_folder/lua"
  ln -sf "$tools_folder/lua/bin/lua" "$bin_folder/lua"
  rm -Rf $downloads_folder/$lua_file
fi

echo ""

# ============================================================================================
# Lua Rocks!
# ============================================================================================

echo "Checking Lua Rocks! installation..."

if [ "$luarocks_bin" = "" ]; then
  echo "Lua Rocks! is not installed, installing..."
  luarocks_install="true"
else
  luarocks_current=$(luarocks --version | grep $luarocks_bin | sed "s|$luarocks_bin ||")
  echo "Lua Rocks! is already installed. [current=$luarocks_current; target=$luarocks_version]"
  if [ "$luarocks_version" != "$luarocks_current" ]; then
    echo "Lua Rocks! version mismatch, replacing installation..."
    luarocks_install="true"
    bash -c "cd $sources_folder/$luarocks_filename && make uninstall"
    rm -rf $tools_folder/luarocks
  fi
fi

if [ "$luarocks_install" != "" ]; then
  rm -Rf $downloads_folder/$luarocks_file
  echo "Downloading LuaRocks! from $luarocks_url"
  curl -L --output $downloads_folder/$luarocks_file $luarocks_url

  rm -Rf $sources_folder/$luarocks_filename
  tar -xzf $downloads_folder/$luarocks_file -C $sources_folder

  mkdir -p $tools_folder/luarocks
  bash -c "cd $sources_folder/$luarocks_filename && ./configure --prefix=$tools_folder/luarocks --with-lua=$tools_folder/lua && make && make install"
  ln -sf "$tools_folder/luarocks/bin/luarocks" "$bin_folder/luarocks"
  rm -Rf $downloads_folder/$luarocks_file
fi

echo ""

# ============================================================================================
# LazyGit
# ============================================================================================

echo "Checking LazyGit installation..."

if [ "$lazygit_bin" = "" ]; then
  echo "LazyGit is not installed, installing..."
  lazygit_install="true"
else
  lazygit_current=$(lazygit --version | sed "s|.*, version=||" | sed "s|, os=.*||")
  echo "LazyGit is already installed. [current=$lazygit_current; target=$lazygit_version]"
  if [ "$lazygit_version" != "$lazygit_current" ]; then
    echo "LazyGit version mismatch, replacing installation..."
    lazygit_install="true"
    rm -rf $tools_folder/lazygit
  fi
fi

if [ "$lazygit_install" != "" ]; then
  rm -Rf $downloads_folder/$lazygit_file
  echo "Downloading LazyGit from $lazygit_url"
  curl -L --output $downloads_folder/$lazygit_file $lazygit_url

  rm -Rf $tools_folder/$lazygit_filename
  mkdir -p $tools_folder/lazygit
  tar -xf $downloads_folder/$lazygit_file -C $tools_folder/lazygit

  ln -sf "$tools_folder/lazygit/lazygit" "$bin_folder/lazygit"
  rm -Rf $downloads_folder/$lazygit_file
fi

echo ""

# ============================================================================================
# NodeJS
# ============================================================================================

echo "Checking NodeJS installation..."

if [ "$nodejs_bin" = "" ]; then
  echo "NodeJS is not installed, installing..."
  nodejs_install="true"
else
  nodejs_current=$(node --version)
  echo "NodeJS is already installed. [current=$nodejs_current; target=$nodejs_version]"
  if [ "$nodejs_version" != "$nodejs_current" ]; then
    echo "NodeJS version mismatch, replacing installation..."
    nodejs_install="true"
    rm -rf $tools_folder/$nodejs_filename
  fi
fi

if [ "$nodejs_install" != "" ]; then
  rm -Rf $downloads_folder/$nodejs_file
  echo "Downloading NodeJS from $nodejs_url"
  curl -L --output $downloads_folder/$nodejs_file $nodejs_url

  rm -Rf $tools_folder/$nodejs_filename
  tar -xf $downloads_folder/$nodejs_file -C $tools_folder

  # TODO: add remaining binaries of nodejs bin folder
  # Also check how to deal with globally installed binaries
  mkdir -p $bin_folder/node
  ln -sf "$tools_folder/$nodejs_filename/bin" "$bin_folder/node/bin"
  rm -Rf $downloads_folder/$nodejs_file
fi

echo ""

# ============================================================================================
# ZelliJ
# ============================================================================================

echo "Checking ZelliJ installation..."

if [ "$zellij_bin" = "" ]; then
  echo "ZelliJ is not installed, installing..."
  zellij_install="true"
else
  zellij_current=$(zellij --version | sed "s|zellij ||")
  echo "ZelliJ is already installed. [current=$zellij_current; target=$zellij_version]"
  if [ "$zellij_version" != "$zellij_current" ]; then
    echo "ZelliJ version mismatch, replacing installation..."
    zellij_install="true"
    rm -rf $tools_folder/zellij
  fi
fi

if [ "$zellij_install" != "" ]; then
  rm -Rf $downloads_folder/$zellij_file
  echo "Downloading ZelliJ from $zellij_url"
  curl -L --output $downloads_folder/$zellij_file $zellij_url

  mkdir -p $tools_folder/zellij
  tar -xzf $downloads_folder/$zellij_file -C $tools_folder/zellij

  ln -sf "$tools_folder/zellij/zellij" "$bin_folder/zellij"
  rm -Rf $downloads_folder/$zellij_file
fi

echo ""

# ============================================================================================
# NeoVim
# ============================================================================================

echo "Checking NeoVim installation..."

if [ "$neovim_bin" = "" ]; then
  echo "NeoVim is not installed, installing..."
  neovim_install="true"
else
  neovim_current=$(nvim --version | grep NVIM | sed "s|NVIM ||")
  echo "NeoVim is already installed. [current=$neovim_current; target=$neovim_version]"
  if [ "$neovim_version" != "$neovim_current" ]; then
    echo "NeoVim version mismatch, replacing installation..."
    neovim_install="true"
    rm -rf $apps_folder/$neovim_filename
  fi
fi

if [ "$neovim_install" != "" ]; then
  rm -Rf $downloads_folder/$neovim_file
  echo "Downloading NeoVim from $neovim_url"
  curl -L --output $downloads_folder/$neovim_file $neovim_url

  rm -Rf $apps_folder/$neovim_filename
  tar -xzf $downloads_folder/$neovim_file -C $apps_folder

  ln -sf "$apps_folder/$neovim_filename/bin/nvim" "$bin_folder/nvim"
  rm -Rf $downloads_folder/$neovim_file
  neovim_config_reset="true"
fi

if [ ! -d $neovim_config_folder ]; then
  neovim_config_clone="true"
  echo "No NeoVim config detected, cloning repo $neovim_config_repo into $neovim_config_folder"
else
  neovim_config_repo_current=$(cd $neovim_config_folder && git remote show origin | grep "Fetch URL:" | sed "s|  Fetch URL: ||")
  echo "NeoVim config already exists. [current=$neovim_config_repo_current; target=$neovim_config_repo]"
  if [ "$neovim_config_repo_current" != "$neovim_config_repo" ]; then
    echo "NeoVim repo mismatch, replacing configuration..."
    neovim_config_clone="true"
  fi
fi

if [ "$neovim_config_clone" != "" ]; then
  rm -Rf $neovim_config_folder
  git clone $neovim_config_repo $neovim_config_folder
  neovim_config_reset="true"
fi

if [ "$neovim_config_reset" = "true" ]; then
  echo "Reseting NeoVim configuration state..."
  ./scripts/nvimreset
fi

echo ""

# ============================================================================================
# Nerd Fonts
# ============================================================================================

echo "Checking Nerd Font installation..."

if [ ! -f "$fonts_folder/nerdfonts/.nerdfont_version" ] || [ ! -d $fonts_folder/nerdfonts/$nerdfont_filename ]; then
  echo "Nerd Font is not installed, installing..."
  nerdfont_install="true"
else
  nerdfont_current=$(cat $fonts_folder/nerdfonts/.nerdfont_version)
  echo "Nerd Font is already installed. [current=$nerdfont_current; target=$nerdfont_version]"
  if [ "$nerdfont_version" != "$nerdfont_current" ]; then
    echo "Nerd Font version mismatch, replacing installation..."
    nerdfont_install="true"
    rm -rf $fonts_folder/nerdfonts
  fi
fi

if [ "$nerdfont_install" != "" ]; then
  rm -Rf $downloads_folder/$nerdfont_file
  echo "Downloading Nerd Font from $nerdfont_url"
  curl -L --output $downloads_folder/$nerdfont_file $nerdfont_url

  rm -rf $fonts_folder/nerdfonts/$nerdfont_filename
  mkdir -p $fonts_folder/nerdfonts/$nerdfont_filename
  tar -xf $downloads_folder/$nerdfont_file -C $fonts_folder/nerdfonts/$nerdfont_filename

  font_path="$fonts_folder/nerdfonts/$nerdfont_filename/$font_file"

  [ ! -f $font_path ] && echo "File not found $font_path" && exit 1

  mkdir -p $installed_fonts_folder
  ln -sf $font_path $installed_fonts_folder/DevEnv.$font_extension
  echo $nerdfont_version > $fonts_folder/nerdfonts/.nerdfont_version

  rm -Rf $downloads_folder/$nerdfont_file
fi

mkdir -p $bin_folder/dev_scripts
ln -sf $scripts_folder $bin_folder/dev_scripts/bin
