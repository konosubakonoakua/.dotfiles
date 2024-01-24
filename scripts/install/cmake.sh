#!/bin/bash

#INFO: tested, works

PKG_FOLDER=~/Downloads/cmake
INSTALL_PREFIX=$HOME/.local/

# https://github.com/Kitware/CMake/releases/download/v3.28.0-rc1/cmake-3.28.0-rc1-linux-x86_64.sh
version_latest=$(
	curl -L https://github.com/Kitware/CMake/releases/ |
		grep -oE '>v[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' |
		sort -r --version-sort | uniq | sed 's/>v//' | awk 'NR==1{print $1}'
)

echo "Found glow latest veriosn: $version_latest"
# Define the CMake download URL
CMAKE_DOWNLOAD_URL="https://github.com/Kitware/CMake/releases/download/v3.21.0/cmake-3.21.0-Linux-x86_64.sh"

# Define the installation directory
INSTALL_DIR=$INSTALL_PREFIX/opt/cmake
echo "mkdir: $INSTALL_DIR"
mkdir -p $INSTALL_DIR

# Download the CMake installer script
wget $CMAKE_DOWNLOAD_URL -O cmake-install.sh

# Make the installer script executable
chmod +x cmake-install.sh

# Run the installer with administrative privileges
./cmake-install.sh --skip-license --prefix=$INSTALL_DIR

# Add CMake to the system's PATH
echo "export PATH=$INSTALL_DIR/bin:\$PATH:" >>~/.bashrc
source ~/.bashrc

# Clean up the installer script
rm cmake-install.sh

# Print CMake version to verify installation
$(
    source ~/.bashrc
    cmake --version
)
