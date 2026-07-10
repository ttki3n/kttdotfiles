# Linux

## checkout .dotfiles
```bash
mkdir ~/.config
cd ~/.dotfiles/dotfiles
stow .
```

## install zsh and omz
zsh-omz-agnoster-fonts.sh


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