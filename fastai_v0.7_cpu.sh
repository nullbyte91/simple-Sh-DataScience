#!/bin/bash

# Copyright (c) 2018 Jegathesan Shanmugam
# Released under the MIT License (MIT)
# https://github.com/nullbyte91/Simple-Sh-DataScience/blob/master/LICENSE.md

# Title           : fastai_v0.7_gpu.sh
# Description     : This script to install fast.ai cpu env on ubuntu system
# author	  : Jegathesan Shanmugam

fAnaconda2Sh="Anaconda2-4.2.0-Linux-x86_64.sh"
dAnaconda2Install="$HOME/anaconda2/"
python3="python3-dev"
pip3="python3-pip"

function installConda()
{
    # Install Anaconda for current user
    mkdir downloads
    cd downloads
    if [ ! -f ${fAnaconda2Sh} ];
    then
        wget "https://repo.continuum.io/archive/Anaconda2-4.2.0-Linux-x86_64.sh" -O ${fAnaconda2Sh}
    fi

    if [ -d ${dAnaconda2Install} ];
    then
        echo "Anaconda already installed"
        read -r -p " Do you wanna delete and install it again[Y/n]" condaResponse
        if [[ "$condaResponse" =~ ^([yY][eE][sS]|[yY])+$ ]]
        then
            rm -rf ${dAnaconda2Install}
            bash ${fAnaconda2Sh} -b
            conda install -y bcolz
            conda upgrade -y --all
        fi
    else
        bash ${fAnaconda2Sh} -b
        echo "export PATH=\"$HOME/anaconda2/bin:\$PATH\"" >> ~/.bashrc
        #conda2 Env update
        export PATH="$HOME/anaconda2/bin:$PATH"

        #Proxy config if your behind the Corporate Proxy
        read -r -p " Are you behind the Corporate Proxy[Y/n]" proxyYes
        if [[ "$proxyYes" =~ ^([yY][eE][sS]|[yY])+$ ]];
        then
            read -r -p " Type Proxy IP address[host:port]" proxyIP
            touch ~/.condarc
            echo "http: http://${proxyIP}
https: https://${proxyIP}
ssl_verify: False" >> ~/.condarc

            #Configure proxy for pip
            echo "export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt python" >> ~/.bashrc
        fi
    fi
}

function installFastaiCPU()
{
    mkdir -v ~/fast.ai
    cd ~/fast.ai
    git clone https://github.com/fastai/fastai.git
    cd fastai
    conda env create -f environment-cpu.yml

    #Activate conda env for fastai-cpu

    echo "List conv env: by typing conda info --envs"
    echo "run the below command on terminal:"
    echo "source activate fast_ai env"
    echo "Run jupyter notebook"
}

#MainStartsHere
source ./helper_function.sh
#systemBasicUpdates

#Install Python3 Package
installAptPackages ${python3}

#Install Python3 pip package manager
installAptPackages ${pip3}

#Install conda
installConda

#Install fast.ai as per jeremy thread
installFastaiCPU

