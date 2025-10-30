PLATFORM ?= linux
ARCH ?= amd64

LUA_VERSION ?= 5.1.5
LUAROCKS_VERSION ?= 3.12.2
LAZYGIT_VERSION ?= 0.55.1
NODEJS_VERSION ?= v22.20.0
ZELLIJ_VERSION ?= 0.43.1
NEOVIM_VERSION ?= v0.11.4
NERDFONT_VERSION ?= v3.4.0
GOLANG_VERSION ?= 1.25.3
RIPGREP_VERSION ?= 15.1.0
FD_VERSION ?= 10.3.0

NEOVIM_CONFIG_REPO ?= git@github.com:leandrohsilveira/nvim-config.git
FONT_FILENAME ?= FiraCode

install: configs_sync devscripts zellij neovim

sync: configs_sync devscripts_sync lua_sync luarocks_sync lazygit_sync zellij_sync ripgrep_sync fd_sync neovim_sync nodejs_sync

lua:
	@sh -c "./installs/lua run $(LUA_VERSION) $(PLATFORM)"

lua_sync:
	@sh -c "./installs/lua sync $(LUA_VERSION) $(PLATFORM)"

luarocks: lua luarocks_only 

luarocks_sync:
	@sh -c "./installs/luarocks sync $(LUAROCKS_VERSION)"

luarocks_only:
	@sh -c "./installs/luarocks run $(LUAROCKS_VERSION)"

lazygit:
	@sh -c "./installs/lazygit run $(LAZYGIT_VERSION) $(PLATFORM) $(ARCH)"

lazygit_sync:
	@sh -c "./installs/lazygit sync $(LAZYGIT_VERSION) $(PLATFORM) $(ARCH)"

nodejs:
	@sh -c "./installs/nodejs run $(NODEJS_VERSION) $(PLATFORM) $(ARCH)"

nodejs_sync:
	@sh -c "./installs/nodejs sync $(NODEJS_VERSION) $(PLATFORM) $(ARCH)"

zellij: nerdfont
	@sh -c "./installs/zellij run $(ZELLIJ_VERSION) $(PLATFORM) $(ARCH)"

zellij_sync:
	@sh -c "./installs/zellij sync $(ZELLIJ_VERSION) $(PLATFORM) $(ARCH)"

ripgrep:
	@sh -c "./installs/ripgrep run $(RIPGREP_VERSION) $(PLATFORM) $(ARCH)"

ripgrep_sync:
	@sh -c "./installs/ripgrep sync $(RIPGREP_VERSION) $(PLATFORM) $(ARCH)"

fd:
	@sh -c "./installs/fd run $(FD_VERSION) $(PLATFORM) $(ARCH)"

fd_sync:
	@sh -c "./installs/fd sync $(FD_VERSION) $(PLATFORM) $(ARCH)"

neovim: luarocks lazygit nodejs ripgrep fd
	@sh -c "./installs/neovim run $(NEOVIM_VERSION) $(PLATFORM) $(ARCH) $(NEOVIM_CONFIG_REPO)"

neovim_sync:
	@sh -c "./installs/neovim sync $(NEOVIM_VERSION) $(PLATFORM) $(ARCH) $(NEOVIM_CONFIG_REPO)"

nerdfont:
	@sh -c "./installs/nerdfont run $(NERDFONT_VERSION) $(FONT_FILENAME)"

devscripts:
	@sh -c "./installs/devscripts run"

devscripts_sync:
	@sh -c "./installs/devscripts sync"

golang:
	@sh -c "./installs/golang run $(GOLANG_VERSION) $(PLATFORM) $(ARCH)"

golang_sync:
	@sh -c "./installs/golang sync $(GOLANG_VERSION) $(PLATFORM) $(ARCH)"

ohmyzsh:
	@sh -c "./installs/ohmyzsh run"

configs_sync:
	@sh -c "./configs.sh"

