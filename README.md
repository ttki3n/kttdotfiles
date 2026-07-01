# ktt_simple_linux_configs

## install zsh and omz
zsh-omz-agnoster-fonts.sh

## checkout .dotfiles
mkdir ~/.config
cd ~/.dotfiles/dotfiles
stow .

## symlink .zshrc to dotfiles
ln -sf ~/.config/zshrc/.zshrc ~/.zshrc

## install neovim