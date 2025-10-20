# Dev environment starter

Scripts to create a development environment containing:

- **Wezterm** as terminal emulator
- **Zsh** + **Oh my Zsh** as shell environment
- **ZelliJ** as shell session manager
- **NeoVim** as IDE (Installing Lua, LuaRocks! and NodeJS)

## Creating environment

1. `sudo ./prepare.sh` to run `apt` update & install binaries like fzf, wezterm...
2. `./install.sh` to install fonts from NerdFonts, tools like Zellij, Lua, Lua Rocks!, NodeJS, LazyGit and apps like NeoVim. Does not require sudo because it installs everything into `$HOME` folder
3. `./configs.sh` to install shell and tools configurations.

## Updating environment

Run steps 2 and 3 of the [Creating environment](#creating-environment) section.
