# Linux

## install zsh and omz
zsh-omz-agnoster-fonts.sh

## checkout .dotfiles
mkdir ~/.config
cd ~/.dotfiles/dotfiles
stow .

## symlink .zshrc to dotfiles
ln -sf ~/.config/zshrc/.zshrc ~/.zshrc

## install neovim


# Windows
## Install busybox
[busybox-w32](https://frippery.org/busybox/) is a port of BusyBox to the Microsoft Windows WIN32 API

## Install Clink, 
- Change Starship config in `%localappdata%\clink`
```lua
-- starship.lua
local userProfile = os.getenv("USERPROFILE")
os.setenv('STARSHIP_CONFIG', userProfile..'\\.config\\starship\\starship.toml')

load(io.popen('starship init cmd'):read("*a"))()
```


## Install neovim

## 