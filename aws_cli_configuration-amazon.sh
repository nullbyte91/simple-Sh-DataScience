#!/bin/bash

python2="python-dev"
pip2="python-pip"
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
}

function basicUpdate()
{
	# Update the apt package index and Upgrade the Ubuntu system
	sudo apt-get update 
	if [[ $? > 0 ]]
	then
    	echo "apt-get update failed, exiting."
    	exit
	else
    	echo "apt-get update ran succesfuly, continuing with script."
	fi
	sudo apt-get -y upgrade
	if [[ $? > 0 ]]
	then
    	echo "apt-get upgrade failed, exiting."
    	exit
	else
    	echo "apt-get upgrade ran succesfuly, continuing with script."
	fi
}

function installAptPackage()
{
    for pkg in $1; do
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
}

function verifyAws()
{
	echo "##### Test credentials for AWS Command Line Tools #####"
	aws sts get-caller-identity
}

#MainStartsHere
basicUpdate

#Install Python2 & Python2 PIP if already not installed
installAptPackage ${python2}
installAptPackage ${pip2}

#Installing AWS CLI tool using apt
installAptPackage ${AWS_CLI}
#Installing AWS CLI 
echo "AWS CLI Version:"
aws --version

#AWS CLI Configuration
echo "#### AWS Configuration"
read -r -p "Do you wanna configure AWS CLI?[Y/N]" response
	if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
	then
		configureAWS
	else
    		echo "Assume you have done the AWS configuration already"
	fi

verifyAws