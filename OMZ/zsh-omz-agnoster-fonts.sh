#!/bin/bash

set -e

echo "Zsh, Oh-My-Zsh and agnoster, p10k setup script"
sudo apt update

# 1. Install tools
if command -v git &> /dev/null; then
    echo "✓ Git already installed, skipping..."
else
    echo "Installing git..."
    sudo apt install git -y
fi
if command -v curl &> /dev/null; then
    echo "✓ Curl already installed, skipping..."
else
    echo "Installing curl..."
    sudo apt install curl -y
fi
if command -v zsh &> /dev/null; then
    echo "✓ Zsh already installed, skipping..."
else
    echo "Installing Zsh..."
    sudo apt install zsh -y
fi

# 2.1 Install Oh-My-Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "✓ Oh-My-Zsh already installed, skipping..."
else
    echo "Installing Oh-My-Zsh..."
    # unattended may not work. Removing it will require to run script 2 times : 1st for installing oh-my-zsh, 2nd for the rest.
    # sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# 2.2 Override .zshrc with the one provided in this repo
#read -r -p "Do you want to override ~/.zshrc with the one provided in this repo? (Y/n): " override_zshrc
#override_zshrc=${override_zshrc:-Y}
#
#if [[ "$override_zshrc" =~ ^[Yy]$ ]]; then
#  if [[ -f "$HOME/.zshrc" || -L "$HOME/.zshrc" ]]; then
#    cp "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%s)"
#  fi
#
#  ln -sf "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/dotfiles/zshrc/.zshrc" "$HOME/.zshrc"
#fi

# 3. Clone plugins
echo "Setting ZSH_CUSTOM if not already set..."
export ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
#export ZSH_CUSTOM="${ZSH_CUSTOM:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.oh-my-zsh/custom}"

echo "Installing plugins..."
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && echo "✓ zsh-autosuggestions already installed" || git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && echo "✓ zsh-syntax-highlighting already installed" || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
[ -d "$ZSH_CUSTOM/plugins/zsh-completions" ] && echo "✓ zsh-completions already installed" || git clone https://github.com/zsh-users/zsh-completions.git $ZSH_CUSTOM/plugins/zsh-completions

# sed -i will break the symlink. We will change it at step 6
# sed -i 's/plugins=(.*)/plugins=(git z dirhistory colorize colored-man-pages sudo zsh-syntax-highlighting zsh-autosuggestions zsh-completions)/' ~/.zshrc

# 4. Install fonts
echo "Installing MesloLGS NF fonts..."
mkdir -p ~/.local/share/fonts
[ -f ~/.local/share/fonts/MesloLGSNFRegular.ttf ] && echo "✓ MesloLGS NF Regular already installed" || wget -O ~/.local/share/fonts/MesloLGSNFRegular.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
[ -f ~/.local/share/fonts/MesloLGSNFBold.ttf ] && echo "✓ MesloLGS NF Bold already installed" || wget -O ~/.local/share/fonts/MesloLGSNFBold.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
[ -f ~/.local/share/fonts/MesloLGSNFItalic.ttf ] && echo "✓ MesloLGS NF Italic already installed" || wget -O ~/.local/share/fonts/MesloLGSNFItalic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
[ -f ~/.local/share/fonts/MesloLGSNFBoldItalic.ttf ] && echo "✓ MesloLGS NF Bold Italic already installed" || wget -O ~/.local/share/fonts/MesloLGSNFBoldItalic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

read -p "Do you want to install Powerline fonts? [y/N]: " response
response=${response,,}
if [[ "$response" == "y" || "$response" == "yes" ]]; then
    echo "Starting installation of fonts-powerline..."
    sudo apt-get install -y fonts-powerline
else
    echo "Installation skipped."
fi

# Check if fc-cache is available
if command -v fc-cache &> /dev/null; then
    echo "✓ fontconfig already installed"
    fc-cache -f -v
else
    echo ""
    echo "fontconfig (fc-cache) is not installed."
    echo "fc-cache helps your system recognize the new fonts immediately."
    read -p "Would you like to install fontconfig? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Installing fontconfig..."
        sudo apt update
        sudo apt install fontconfig -y
        echo "Running fc-cache to update font cache..."
        fc-cache -f -v
    else
        echo "Skipping fontconfig installation. Fonts installed but may require a logout/login to take effect."
    fi
fi

# 5. Install theme
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "✓ Powerlevel10k already installed, skipping..."
else
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

mkdir -p "$ZSH_CUSTOM/themes/agnoster"
ln -sf "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/agnoster.zsh-theme" "$ZSH_CUSTOM/themes/agnoster/agnoster.zsh-theme"

# 6. Enable plugins and theme
# if [[ "$override_zshrc" =~ ^[Nn]$ ]]; then
#   echo "Enabling plugins, theme..."
#   touch ~/.zshrc
#   sed -i 's/plugins=(.*)/plugins=(git z dirhistory colorize colored-man-pages sudo zsh-syntax-highlighting zsh-autosuggestions zsh-completions)/' ~/.zshrc
#   sed -i 's/ZSH_THEME=".*"/ZSH_THEME="agnoster\/agnoster"/' ~/.zshrc
# fi

# 7. Set zsh as default
chsh -s $(which zsh)

echo "Setup complete!"
exit 0

# 7. 
echo "Attempting to set MesloLGS NF font in terminal emulator..."

# GNOME Terminal
if command -v gsettings &> /dev/null; then
    PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
    if [ -n "$PROFILE" ]; then
        gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ font 'MesloLGS NF 11'
        gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ use-system-font false
        echo "✓ GNOME Terminal font set"
    fi
fi

# XFCE Terminal
if [ -f ~/.config/xfce4/terminal/terminalrc ]; then
    if grep -q "^FontName=" ~/.config/xfce4/terminal/terminalrc; then
        sed -i 's/^FontName=.*/FontName=MesloLGS NF 11/' ~/.config/xfce4/terminal/terminalrc
    else
        echo "FontName=MesloLGS NF 11" >> ~/.config/xfce4/terminal/terminalrc
    fi
    echo "✓ XFCE Terminal font set"
fi

# Konsole
if [ -d ~/.local/share/konsole ]; then
    for profile in ~/.local/share/konsole/*.profile; do
        if [ -f "$profile" ]; then
            if grep -q "^Font=" "$profile"; then
                sed -i 's/^Font=.*/Font=MesloLGS NF,11,-1,5,50,0,0,0,0,0/' "$profile"
            else
                echo "Font=MesloLGS NF,11,-1,5,50,0,0,0,0,0" >> "$profile"
            fi
        fi
    done
    echo "✓ Konsole font set"
fi

# Alacritty
if [ -f ~/.config/alacritty/alacritty.yml ] || [ -f ~/.config/alacritty/alacritty.toml ]; then
    mkdir -p ~/.config/alacritty
    if [ -f ~/.config/alacritty/alacritty.toml ]; then
        if grep -q "^\[font\]" ~/.config/alacritty/alacritty.toml; then
            sed -i '/^\[font\]/,/^\[/ s/^family = .*/family = "MesloLGS NF"/' ~/.config/alacritty/alacritty.toml
        else
            echo -e "\n[font]\nfamily = \"MesloLGS NF\"" >> ~/.config/alacritty/alacritty.toml
        fi
        echo "✓ Alacritty font set"
    fi
fi

# Kitty
if [ -f ~/.config/kitty/kitty.conf ]; then
    if grep -q "^font_family" ~/.config/kitty/kitty.conf; then
        sed -i 's/^font_family.*/font_family MesloLGS NF/' ~/.config/kitty/kitty.conf
    else
        echo "font_family MesloLGS NF" >> ~/.config/kitty/kitty.conf
    fi
    echo "✓ Kitty font set"
fi

echo "Setup complete!"
echo ""
echo "Font configuration attempted for detected terminal emulators."
echo "If your terminal font didn't change, you may need to set it manually to 'MesloLGS NF'."
echo "Launching Zsh now... Powerlevel10k configuration wizard will run."
echo ""

exec zsh