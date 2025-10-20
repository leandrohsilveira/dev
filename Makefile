PLATFORM=linux
ARCH=amd64
ARCH_BITS=x86_64
SOURCES="./.sources"
DOWNLOADS="./.downloads"

# Packages versions
NEOVIM_VERSION=v0.11.4
LUA_VERSION=5.1.5
LUAROCKS_VERSION=3.12.2

# Packages File Names
NEOVIM_FILE=nvim-$PLATFORM-$ARCH.tar.gz
LUA_FILE=lua-$LUA_VERSION.tar.gz
LUAROCKS_FILE=luarocks-$LUAROCKS_VERSION.tar.gz

# Packages URLs
NEOVIM_URL=https://github.com/neovim/neovim/releases/download/$NEOVIM_VERSION/$NEOVIM_FILE
LUA_URL=https://www.lua.org/ftp/$LUA_FILE
LUAROCKS_URL=https://luarocks.github.io/luarocks/releases/$LUAROCKS_FILE
