#!/bin/bash

# Copyright (c) 2018 Jegathesan Shanmugam
# Released under the MIT License (MIT)
# https://github.com/nullbyte91/Simple-Sh-DataScience/blob/master/LICENSE.md

# Title           : helper_function.sh
# Description     : This script contains helper function to support other bash scripts
# author		  : Jegathesan Shanmugam

function systemBasicUpdates()
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

function installAptPackages()
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

function installPipPackages()
{
    echo "Note: Pip install with  --user Mode"
    echo "$1 & $2"
    if [ "$1" == "2" ];
        then
        pip install $2 --user
    else  
        pip3 install $2 --user
    fi
}