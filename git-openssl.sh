#!/bin/bash

	
sudo apt-get install -y build-essential fakeroot dpkg-dev
sudo apt-get -y build-dep git
sudo apt-get install -y libcurl4-openssl-dev

mkdir git-openssl
cd git-openssl
apt-get source git
cd git-*
sed -i -e 's/libcurl4-gnutls-dev/libcurl4-openssl-dev/g' ./debian/control
sed -i -- '/TEST\s*=\s*test/d' ./debian/rules
sudo dpkg-buildpackage -rfakeroot -b
sudo dpkg -i git_2.7.4-0ubuntu1.6_arm64.deb

#CleanUp
cd ../../
sudo rm -rf git-openssl

#Set git set on hold from apt-get/dpkg update
sudo apt-mark hold git
#Ref:
#https://devopscube.com/gnutls-handshake-failed-aws-codecommit/






