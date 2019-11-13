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
    cd git-openssl
    apt-get source git
    cd git-*
    sed -i -e 's/libcurl4-gnutls-dev/libcurl4-openssl-dev/g' ./debian/control
    sed -i -- '/TEST\s*=\s*test/d' ./debian/rules
    sudo dpkg-buildpackage -rfakeroot -b
    find .. -type f -name "git_*ubuntu*.deb" -exec sudo dpkg -i \{\} \;
    cd ../../
}

function cleanUp()
{
    mkdir -p ../gitopenssl_deb
    pushd git-openssl
    # copy the package for future use
    find .. -type f -name "git_*ubuntu*.deb" -exec cp {} ../../gitopenssl_deb \;
    popd
    
    # Cleanup the compilation env
    sudo rm -rf git-openssl
}

#Main
#dep install
installDep

# compile git with openssl
compileGit

# Put git on hold from software update
sudo apt-mark hold git

# cleanUp
cleanUp