#!/bin/bash

# Reference
# https://askubuntu.com/questions/355565/how-do-i-install-the-latest-version-of-cmake-from-the-command-line

# Tested on Ubuntu 18.04

# Remove older cmake 
sudo apt remove --purge --auto-remove cmake

# Dep install
sudo apt-get update && sudo apt-get install libssl-dev

# Install 
version=3.18
build=1
mkdir ~/temp
cd ~/temp
wget https://cmake.org/files/v$version/cmake-$version.$build.tar.gz
tar -xzvf cmake-$version.$build.tar.gz
cd cmake-$version.$build/

# Build
./bootstrap
make -j$(nproc)
sudo make install
sudo ldconfig

# Test cmake version
cmake --version

# Remove the older package
cd ~/
rm -rf ~/temp




