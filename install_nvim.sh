#!/bin/bash

# 1. Get the version from the user
read -p "Enter Neovim version (e.g., 0.10.0): " VERSION

# Clean the version string (remove dots) for the folder name
FOLDER_NAME="nvim${VERSION//./}"
FILE_NAME="nvim-linux-x86_64.tar.gz"
DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/v${VERSION}/${FILE_NAME}"
INSTALL_DIR="$HOME/$FOLDER_NAME"

echo "Attempting to install Neovim v$VERSION to $INSTALL_DIR..."

# 2. Create the directory and download
mkdir -p "$INSTALL_DIR"
cd /tmp

echo "Downloading from: $DOWNLOAD_URL"
curl -LO "$DOWNLOAD_URL"

# Check if download was successful
if [ $? -ne 0 ]; then
    echo "Error: Could not download version $VERSION. Please check the version number."
    exit 1
fi

# 3. Extract the contents
# --strip-components=1 removes the top-level 'nvim-linux64' folder from the archive
tar -xzf $FILE_NAME -C "$INSTALL_DIR" --strip-components=1

# 4. Create symlink
# This creates a symlink in ~/.local/bin (ensure this is in your $PATH)
mkdir -p "$HOME/.local/bin"
# NVIM_PATH="/usr/bin/nvim"
NVIM_PATH="$HOME/.local/bin/nvim"
sudo ln -sf "$INSTALL_DIR/bin/nvim" "${NVIM_PATH}"

echo "------------------------------------------------"
echo "Success! Neovim $VERSION installed at $INSTALL_DIR"
echo "Symlink created at $NVIM_PATH"
echo "Make sure $HOME/.local/bin is in your PATH."