#!/bin/bash

# Define version variables
TERRAFORM_VERSION="1.8.2"
VAULT_VERSION="1.16.2"

# Detect OS and Architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Map architectures
if [[ "$ARCH" == "x86_64" ]]; then
    ARCH="amd64"
elif [[ "$ARCH" == "aarch64" ]]; then
    ARCH="arm64"
elif [[ "$ARCH" == "i386" || "$ARCH" == "i686" ]]; then
    ARCH="386"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Check if Terraform and Vault are already installed
if command -v terraform &> /dev/null && command -v vault &> /dev/null; then
    echo "Terraform and Vault are already installed."
else
    echo "Installing Terraform and/or Vault..."

    # Define the binary directory based on OS
    if [[ "$OS" == "linux" || "$OS" == "darwin" ]]; then
        BIN_DIR="/usr/local/bin"
    elif [[ "$OS" == "windows" ]]; then
        BIN_DIR="$HOME/bin"
        mkdir -p "$BIN_DIR"
    else
        echo "Unsupported OS: $OS"
        exit 1
    fi

    # Terraform and Vault URLs
    TERRAFORM_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${OS}_${ARCH}.zip"
    VAULT_URL="https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_${OS}_${ARCH}.zip"

    # Download and install Terraform
    echo "Downloading Terraform version $TERRAFORM_VERSION..."
    curl -o terraform.zip "$TERRAFORM_URL"

    echo "Installing Terraform..."
    unzip terraform.zip -d "$BIN_DIR"
    rm terraform.zip

    # Download and install Vault
    echo "Downloading Vault version $VAULT_VERSION..."
    curl -o vault.zip "$VAULT_URL"

    echo "Installing Vault..."
    unzip vault.zip -d "$BIN_DIR"
    rm vault.zip

    # Export PATH (needed for non-standard paths like on Windows)
    export PATH="$BIN_DIR:$PATH"

    echo "Terraform and Vault installation complete."
fi
