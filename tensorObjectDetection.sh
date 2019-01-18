#!/bin/bash

# Copyright (c) 2018 Jegathesan Shanmugam
# Released under the MIT License (MIT)
# https://github.com/nullbyte91/Simple-Sh-DataScience/blob/master/LICENSE.md

# Title           : tensorObjectDetection.sh
# Description     : This script to install tensorflow object detection on virtual env(https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/installation.md)
# author		  : Jegathesan Shanmugam

python3="python3-dev"
pip3="python3-pip"
virtEnv="virtualenv"
deepSpeech="deepspeech"
protobuf="protobuf-compiler"
pythonPil="python-pil"
pythonLxml="python-lxml"
pythonTk="python-tk"
function virt_activate()
{
    echo "$1"
    source virtualenv_activate.sh $1
}

#MainStartsHere
source ./helper_function.sh
#systemBasicUpdates 

read -r -p "Select the folder to work on objectDetection:[/home/user/objectDetection]" workPath
if [ "${workPath}" == "" ]
then
    objectDetection="/home/$USER/objectDetection"
else
    objectDetection=${workPath}
fi
    
if [[ ! -e ${objectDetection} ]]
then
    mkdir -p ${objectDetection}
fi

#Before Push to your working dir copy virtualenv_activate.sh
cp virtualenv_activate.sh ${objectDetection}

# We need to create a virtual env for deep Speech
echo "Using Python 3"
#Install Python3 Package
installAptPackages ${python3}

#Install Python3 pip package manager
installAptPackages ${pip3}

#Install virtualenv Pip package
installPipPackages "3" ${virtEnv}

#Create a virtual env
virtTemp="${objectDetection}/virt_temp"
echo "creating a virtual env.......${virtTemp}"

mkdir -p virt_temp
    
virtualenv --system-site-packages -p python3 ${virtTemp}

#Activate the Virtual Env
virt_activate ${virtTemp}

installAptPackages ${protobuf}
installAptPackages ${pythonPil}
installAptPackages ${pythonLxml}
installAptPackages ${pythonTk}

#Install deepSpeech pip Package
pip3 install -r requirementsFiles/objectDetectionReq.txt

#protobuf-compiler installation and compile
git clone https://github.com/tensorflow/models.git
pushd models/research/
wget -O protobuf.zip https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip
unzip protobuf.zip

./bin/protoc object_detection/protos/*.proto --python_out=.

#Add Libraries to PYTHONPATH
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim

# Testing 
python object_detection/builders/model_builder_test.py

