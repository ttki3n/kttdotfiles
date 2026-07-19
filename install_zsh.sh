#!/bin/bash

set -e

echo "Installing tools, zsh and plugins..."
install_packages() {
  local missing=()
  local failed=()

  for pkg in "$@"; do
    #if command -v "$pkg" >/dev/null 2>&1; then
    if dpkg -s "$pkg" >/dev/null 2>&1; then
      echo "✓ $pkg already installed, skipping..."
    else
      missing+=("$pkg")
    fi
  done

  if ((${#missing[@]} == 0)); then
    echo "All packages are already installed."
    return
  fi

  echo
  echo "Updating package index..."
  sudo apt update

  echo
  for pkg in "${missing[@]}"; do
    echo "Installing $pkg..."

    if sudo apt install -y "$pkg"; then
      echo "✓ Installed $pkg"
    else
      echo "✗ Failed to install $pkg"
      failed+=("$pkg")
    fi
  done

  if ((${#failed[@]})); then
    echo
    echo "The following packages could not be installed:"
    printf '  - %s\n' "${failed[@]}"
  fi
}

install_packages git curl zsh \
  unzip \
  jq \
  bat tree eza zoxide atuin \
  ripgrep fzf fd-find

# Clone plugins
echo "Setting ZSH_CUSTOM if not already set..."
export ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.local/share/zsh}"
mkdir -p "$ZSH_CUSTOM/plugins"

echo "Cloning plugins..."
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && echo "✓ zsh-autosuggestions already installed" || git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && echo "✓ zsh-syntax-highlighting already installed" || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ -d "$ZSH_CUSTOM/plugins/zsh-completions" ] && echo "✓ zsh-completions already installed" || git clone https://github.com/zsh-users/zsh-completions.git "$ZSH_CUSTOM/plugins/zsh-completions"

# Set zsh as default
echo "Set zsh as default..."
#chsh -s $(which zsh)
chsh -s "$(command -v zsh)"

echo "Setup complete!"
exit 0

# Test code ???
clone_if_missing() {
  local repo="$1"
  local dir="$2"

  if [[ -d "$dir" ]]; then
    echo "✓ $(basename "$dir") already installed"
  else
    echo "Installing $(basename "$dir")..."
    git clone --depth=1 "$repo" "$dir"
  fi
}
export ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.local/share/zsh}"
mkdir -p "$ZSH_CUSTOM/plugins"

clone_if_missing \
  "https://github.com/zsh-users/zsh-autosuggestions.git" \
  "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

clone_if_missing \
  "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

clone_if_missing \
  "https://github.com/zsh-users/zsh-completions.git" \
  "$ZSH_CUSTOM/plugins/zsh-completions"
