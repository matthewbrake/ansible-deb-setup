#!/bin/bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Script to install Visual Studio Code using the official Microsoft APT repository on Ubuntu

echo "--- Starting VS Code APT Installation ---"

# 1. Update the package list
echo "Updating package list..."
sudo apt update

# 2. Install necessary packages for HTTPS transport and GPG key handling
echo "Installing prerequisites (wget, apt-transport-https, etc.)..."
sudo apt install -y wget gpg apt-transport-https

# 3. Import Microsoft GPG key
echo "Downloading and installing Microsoft's GPG key..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg

# 4. Add the VS Code repository to the system's list
echo "Adding VS Code repository to system sources..."
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

# 5. Update the package list again to fetch the new repository info
echo "Updating package list with new repository..."
sudo apt update

# 6. Install Visual Studio Code ('code' package)
echo "Installing Visual Studio Code..."
sudo apt install -y code

# 7. Clean up the downloaded GPG key file
rm packages.microsoft.gpg

# 8. Verify installation
if command -v code &> /dev/null
then
    echo "--- Visual Studio Code installed successfully! ---"
    echo "You can run it by typing 'code' in your terminal."
else
    echo "--- ERROR: VS Code installation may have failed. ---"
fi
