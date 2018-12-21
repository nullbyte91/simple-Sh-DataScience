#!/bin/bash

git="git"
function configureGit()
{
	echo "##### Configure Git"
        read -r -p "Enter Git User Name:" userName
        git config --global user.name $userName
        read -r -p "Enter GIT Email ID:" EmailID
        git config --global user.email $EmailID
	echo "Git configuration Detail:"
	git config --list
}
function systemBasicUpdate()
{
	echo "#### Basic ubuntu update"
	# Update the apt package index and Upgrade the Ubuntu system
	sudo apt-get update && sudo apt-get -y upgrade

	#Install Git
	echo "#### Install Git"
	for pkg in $git; do
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

	read -r -p "Do you wanna configure git?[Y/N]" response
	if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
	then
		configureGit
	else
    		echo "Assume you have done the Git configuration already"
	fi
}

#MainStarts Here
systemBasicUpdate
