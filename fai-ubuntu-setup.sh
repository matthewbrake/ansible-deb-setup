#!/bin/bash

# Minimal version - save as minimal_setup.sh

echo "Starting minimal setup..."

# Create black wallpaper
convert -size 1024x768 xc:black "$HOME/black.png"

# Set black background (GNOME)
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/black.png"
gsettings set org.gnome.desktop.screensaver picture-uri "file://$HOME/black.png"

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Create desktop folders
mkdir -p "$HOME/Desktop/Docker-Projects"
mkdir -p "$HOME/Desktop/Config-Files"

echo "Minimal setup complete! Logout required for Docker."
