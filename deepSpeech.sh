#!/bin/bash

# Copyright (c) 2018 Jegathesan Shanmugam
# Released under the MIT License (MIT)
# https://github.com/nullbyte91/Simple-Sh-DataScience/blob/master/LICENSE.md

# Title           : deepSpeech.sh
# Description     : This script use to explore, deploy Deep Speech from Mozilla(https://github.com/mozilla/DeepSpeech)
# author		  : Jegathesan Shanmugam

python3="python3-dev"
pip3="python3-pip"
virtEnv="virtualenv"
deepSpeech="deepspeech"

function virt_activate()
{
    echo "${virtTemp}"
    source virtualenv_activate.sh ${virtTemp}
}

#MainStartsHere
source ./helper_function.sh
#systemBasicUpdates 
echo "############ DeepSpeech - A TensorFlow implementation of Baidu's DeepSpeech architecture #####"
echo "Note: You should have cuda and cuDNN installed"
echo "1. Deep Speech Inference Setup"
echo "2. Deep Speech Inference - Use wav audio file"
read -r -p "select the Option:[]" Option
read -r -p "Select the folder to work on deepSpeech:[/home/user/DeepSpeech]" workPath
if [ "${workPath}" == "" ]
then
    DeepSpeechPath="/home/$USER/DeepSpeech"
else
    DeepSpeechPath=${workPath}
fi

if [ "$Option" == "1" ]
then
    
    if [[ ! -e ${DeepSpeechPath} ]]
    then
        mkdir -p ${DeepSpeechPath}
    fi

    #Before Push to your working dir copy virtualenv_activate.sh
    cp virtualenv_activate.sh ${DeepSpeechPath}
    pushd ${DeepSpeechPath}
    wget -O - https://github.com/mozilla/DeepSpeech/releases/download/v0.3.0/deepspeech-0.3.0-models.tar.gz | tar xvfz -

    # We need to create a virtual env for deep Speech
    echo "Using Python 3"
    #Install Python3 Package
    installAptPackages ${python3}

    #Install Python3 pip package manager
    installAptPackages ${pip3}

    #Install virtualenv Pip package
    installPipPackages "3" ${virtEnv}

    #Create a virtual env
    virtTemp="${DeepSpeechPath}/virt_temp"
    echo "creating a virtual env.......${virtTemp}"

    mkdir -p virt_temp
    
    virtualenv --system-site-packages -p python3 ${virtTemp}

    #Activate the Virtual Env
    virt_activate
    
    #Install deepSpeech pip Package
    installPipPackages "3" ${deepSpeech}

    #deactivate
elif [ "$Option" == "2" ]
then
    read -r -p "Input file:[example.wav]" audioFile
    read -r -p "Give a deepSpeech Env Path:[/home/user/DeepSpeech]" InferencePath
    if [[ ! -e ${InferencePath} ]]
    then
        echo "${DeepSpeechPath} Not availble. Please create first"
        exit 1
    fi
    pushd InferencePath
    if [[ ! -e "models" ]]
    then
        echo "models folder Not availble. Downloading pre-trained model"
        wget -O - https://github.com/mozilla/DeepSpeech/releases/download/v0.3.0/deepspeech-0.3.0-models.tar.gz | tar xvfz -
    fi

    deepspeech --model models/output_graph.pbmm --alphabet models/alphabet.txt --lm models/lm.binary --trie models/trie --audio ${audioFile}
else
    echo "I didn't understand your option"
fi
