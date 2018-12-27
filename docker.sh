#!/bin/bash

# Copyright (c) 2018 Jegathesan Shanmugam
# Released under the MIT License (MIT)
# https://github.com/nullbyte91/Simple-Sh-DataScience/blob/master/LICENSE.md

# Title           : docker.sh
# Description     : This script help you to install docker on ubuntu 16.04
# author		  : Jegathesan Shanmugam

docker="docker"
dockerengine="docker-engine"
dockerio="docker.io"
aptTransportHttps="apt-transport-https"
caCertificates="ca-certificates"
curl="curl"
softwarePropertiesCommon="software-properties-common"
dockerCe="docker-ce"

fDocker="/etc/default/docker"
dDocker="/etc/systemd/system/docker.service.d/"
fhtt="http-proxy.conf"
#MainStartsHere
source ./helper_function.sh

# Remove old version
removeAptPackages ${docker}
removeAptPackages ${dockerengine}
removeAptPackages ${dockerio}

#Basic system update
systemBasicUpdates

#Install basic dep
installAptPackages ${aptTransportHttps}
installAptPackages ${caCertificates}
installAptPackages ${curl}
installAptPackages ${softwarePropertiesCommon}

#Add Docker official GPG Key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#Check Key fingerPrint
sudo apt-key fingerprint 0EBFCD88

#Setup stable repo of docker
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

#Basic system update
systemBasicUpdates

#Install docker 
installAptPackages ${dockerCe}

read -r -p "Are you behind corporate proxy[Y/n]" response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    if [ ! -f ${fDocker} ]; then
        echo "File not found. Creating it"
    fi
    echo "Creating a /etc/default/docker file"
    sudo touch /etc/default/docker
    read -r -p "DNS Address?" DNSAddress
    echo "DOCKER_OPTS="- - dns ${DNSAddress}"" | sudo tee --append /etc/default/docker

    echo "Creating a service file for docker"
    sudo mkdir -p ${dDocker}
    sudo touch ${dDocker}/${fhtt}

    read -r -p "Proxy Address?" ProxyAddress
    echo "[Service]
    Environment="HTTP_PROXY=${ProxyAddress}"
    Environment="HTTPS_PROXY=${ProxyAddress}"
    " | sudo tee --append ${dDocker}/${fhtt}
fi

#Verify that Docker CE is installed correctly by running the hello-world image
sudo docker run hello-world

read -r -p "Add your user to the docker group[Y/n]" response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    sudo usermod -aG docker $USER
fi

echo "checking docker without sudo"
echo "running docker run hello-world"
docker run hello-world

echo "Docker install and configuration is done............"
