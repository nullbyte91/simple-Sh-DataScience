#!/bin/bash

git="git"
gStreamer="libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good 
            gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-doc 
            gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-pulseaudio"
python2="python-dev"
pip2="python-pip"
python3="python3-dev"
pip3="python3-pip"
virtEnv="virtualenv"
future="future"
Jupyter="jupyter"


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
	#Install Gstreamer
	echo "#### Install Gstreamer"
	for pkg in $gStreamer; do
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

function installPipPackage()
{	
	echo "$1"
	echo "$2"

    if [ "$1" == "2" ];
        then
        pip install $2 --user
    else  
        pip3 install $2 --user
    fi
}

#MainStarts Here
systemBasicUpdate
read -r -p "Which Python Version You wanna use?[2/3.7]" response
if [ "$response" == "3" ]
    then
        echo "Using Python 3 Version"
        #Install Python2 Package
        installAptPackage ${python2}

        #Install Python2 pip package manager
        installAptPackage ${pip2}

        #Install virtualenv Pip package
        installPipPackage $response ${virtEnv}

		#Install future: Fix:how-to-solve-readtimeouterror-httpsconnectionpoolhost-pypi-python-org-port
		installPipPackage $response ${future}
    else
        echo "Using Python 2 Version"
		#Install Python3 Package
        installAptPackage ${python3}

        #Install Python3 pip package manager
        installAptPackage ${pip3}

        #Install virtualenv Pip package
        installPipPackage $response ${virtEnv}
		
		#Install future: Fix:how-to-solve-readtimeouterror-httpsconnectionpoolhost-pypi-python-org-port
		installPipPackage $response ${future}
	fi

	read -r -p "Do you wanna Install Jupyter Notebook?[Y/N]" jupterNotebook	
	if [[ "$jupterNotebook" =~ ^([yY][eE][sS]|[yY])+$ ]]
	then
		installAptPackage "ipython" 
		installAptPackage "ipython-notebook"
		installPipPackage $response ${Jupyter}
	fi