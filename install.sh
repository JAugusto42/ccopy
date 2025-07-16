#!/bin/bash

# Install script for ccopy
# Uso: curl -sSL https://raw.githubusercontent.com/JAugusto42/ccopy/main/install.sh | bash

set -e

BINARY_NAME="ccopy"
GITHUB_REPO="JAugusto42/ccopy"
VERSION="latest"

# Detect operating system and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case $ARCH in
    x86_64)
        ARCH="amd64"
        ;;
    arm64|aarch64)
        ARCH="arm64"
        ;;
    *)
        echo "Architecture not supported: $ARCH"
        exit 1
        ;;
esac

# Verify if the OS is Linux
if [ "$OS" != "linux" ]; then
    echo "Works only on Linux."
    exit 1
fi

echo "🚀 Installing $BINARY_NAME for $OS-$ARCH..."

# Create a temp dir
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

DOWNLOAD_URL="https://github.com/$GITHUB_REPO/releases/latest/download/$BINARY_NAME-$OS-$ARCH"
echo "📥 Downloading ..."

if command -v curl >/dev/null 2>&1; then
    curl -sSL "$DOWNLOAD_URL" -o "$BINARY_NAME"
elif command -v wget >/dev/null 2>&1; then
    wget -q "$DOWNLOAD_URL" -O "$BINARY_NAME"
else
    echo "❌ curl ou wget not found. Please install one of them to proceed."
    exit 1
fi

if [ ! -f "$BINARY_NAME" ]; then
    echo "❌ Installation failed."
    exit 1
fi

# Make executable
chmod +x "$BINARY_NAME"

# Installing
if [ -w "/usr/local/bin" ]; then
    mv "$BINARY_NAME" "/usr/local/bin/"
    echo "✅ $BINARY_NAME Installing /usr/local/bin/"
else
    mkdir -p "$HOME/.local/bin"
    mv "$BINARY_NAME" "$HOME/.local/bin/"
    echo "✅ $BINARY_NAME Installing $HOME/.local/bin/"

    if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
        echo "⚠️  Add $HOME/.local/bin to the PATH:"
        echo "    echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
        echo "    source ~/.bashrc"
    fi
fi

if ! command -v xclip >/dev/null 2>&1 && ! command -v xsel >/dev/null 2>&1; then
    echo "⚠️  xclip or xsel not found. Installing xclip..."
    
    if command -v apt >/dev/null 2>&1; then
        sudo apt update && sudo apt install -y xclip
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y xclip
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S xclip
    elif command -v zypper >/dev/null 2>&1; then
        sudo zypper install xclip
    else
        echo "❌ It was not possible to install xclip automatically."
        echo "   Please, install: xclip or xsel"
        exit 1
    fi
fi

# Clean up
cd /
rm -rf "$TMP_DIR"

echo "🎉 All set!"
echo ""
echo "Usage:"
echo "  echo 'Hello World' | $BINARY_NAME"
echo "  ls -la | $BINARY_NAME"
echo "  cat file.txt | $BINARY_NAME"
echo ""
echo "Run '$BINARY_NAME' To show complete help."
