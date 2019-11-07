#!/bin/bash

function installDep()
{
    sudo apt-get install -y build-essential fakeroot dpkg-dev
    sudo apt-get -y build-dep git
    sudo apt-get install -y libcurl4-openssl-dev
}

function compileGit()
{
    mkdir -p git-openssl
    apt-get source git
    cd git-*
    sed -i -e 's/libcurl4-gnutls-dev/libcurl4-openssl-dev/g' ./debian/control
    sed -i -- '/TEST\s*=\s*test/d' ./debian/rules
    sudo dpkg-buildpackage -rfakeroot -b
    find .. -type f -name "git_*ubuntu*.deb" -exec sudo dpkg -i \{\} \;
}

#Main
#dep install
installDep

# compile git with openssl
compileGit

# Put git on hold from software update
sudo apt-mark hold git