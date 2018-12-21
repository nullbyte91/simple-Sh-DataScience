#!/bin/bash

python2="python-dev"
pip2="python-pip"
python3="python3-dev"
pip3="python3-pip"
virtEnv="virtualenv"

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
    echo "$1 & $2"
    if [ "$1" == "2" ];
        then
        pip install $2 --user
    else  
        pip3 install $2 --user
    fi
}

function createVirtualEnv()
{
    echo "$1"
    if [ "$1" == "2" ];
    then
        #Install Python2 Package
        installAptPackage ${python2}

        #Install Python2 pip package manager
        installAptPackage ${pip2}

        #Install virtualenv Pip package
        installPipPackage $1 ${virtEnv}
        else
        #Install Python3 Package
        installAptPackage ${python3}

        #Install Python3 pip package manager
        installAptPackage ${pip3}

        #Install virtualenv Pip package
        installPipPackage $1 ${virtEnv}
    fi
}

#MainStarts
read -r -p "Which Python Version You wanna use?[2/3.7]" response
if [ "$response" == "3" ]
    then
        echo "Using Python 3 Version"
        createVirtualEnv "3"
    else
        echo "Using Python 2.7 Version"
        createVirtualEnv "2"
        response="2.7"
        echo $response
    fi

read -r -p "Give a path to create a Python virtual env without /?[eg:/home/Username]" virtPath

AcPath="$virtPath"/virtEnv_"$response"

virtualenv --system-site-packages -p python$response $AcPath
#Activate the virtual environment using a shell-specific command:
source $AcPath/bin/activate

#Install the TensorFlow pip package
read -r -p "CPU or GPU Support Tensorflow?[CPU/GPU]" hwOption
if [ "$hwOption" == "CPU" ]
    then
        #Install Tensorflow CPU
        pip install --upgrade tensorflow
        #Verify Tensorflow CPU
        python -c "import tensorflow as tf; tf.enable_eager_execution(); print(tf.reduce_sum(tf.random_normal([1000, 1000])))"
    else
        echo "Hello"

    fi

deactivate 



