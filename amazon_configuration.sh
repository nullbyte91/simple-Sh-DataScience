#!/bin/bash

PIP="python-pip"
AWS_CLI="awscli"

function configureAWS()
{
	echo "Note:"
	echo "To get a list of Region list:https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html"
	read -r -p "Enter AWS CLI UserName?[Y/N]" UserName
	aws configure --profile $UserName
	echo "amazon CLI details:"
	cat ~/.aws/config
	cat ~/.aws/credentials
	
	#To:do
	#Verify the AMS CLI with cloud
}
echo "#### Basic ubuntu update"
# Update the apt package index and Upgrade the Ubuntu system
sudo apt-get update && sudo apt-get -y upgrade

#Install PIP if already not installed
echo "#### Install PIP"
for pkg in $PIP; do
    if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; then
        echo -e "$pkg is already installed"
	else
		if sudo apt-get -qq install $pkg; then
    		echo "Successfully installed $pkg"
		else
    		echo "Error installing $pkg"
		fi
	fi
done

#Installing AWS CLI 
echo "#### Install AWS_CLI"
for pkg in $AWS_CLI; do
    if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; then
        echo -e "$pkg is already installed"
	else
		if sudo apt-get -qq install $pkg; then
    		echo "Successfully installed $pkg"
		else
    		echo "Error installing $pkg"
		fi
	fi
done
echo "AWS CLI Version:"
aws --version

#AWS CLI Configuration
echo "#### AWS Configuration"
read -r -p "Do you wanna configure AWS CLI?[Y/N]" response
	if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
	then
		configureAWS
	else
    		echo "Assume you have done the Git configuration already"
	fi