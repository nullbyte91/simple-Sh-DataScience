#!/bin/bash

MPI_ROOT=
CUDA_ROOT=
CUDNN_PATH=
NCCL_PATH=

function cudaInstall()
{
    #create temp dir
    CUR_PATH=$(pwd)
    mkdir -p -v $CUR_PATH/temp
    tempPath="$CUR_PATH/temp"
    cd $tempPath
    if [ ! -f rebootFlag ]; then
        if [ ! -f cuda_9.0.176_384.81_linux-run ]; then
            wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run
        fi
        chmod +x cuda_9.0.176_384.81_linux-run
        ./cuda_9.0.176_384.81_linux-run --extract=$tempPath
        pwd
        sudo ./cuda-linux.9.0.176-22781540.run

        read -r -p "Do you wanna verify our CUDA Installation?[Y/N]" response
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
        then
            touch verifyFlag
            sudo ./cuda-samples.9.0.176-22781540-linux.run
        else
            echo "Skipping, CUDA verfication"
        fi

        #configure the runtime library
        sudo bash -c "echo /usr/local/cuda/lib64/ > /etc/ld.so.conf.d/cuda.conf"
        sudo ldconfig

        touch rebootFlag
        echo "Note:"
        echo "Update the below steps manually:"
        echo "$ sudo vim /etc/environment"
        echo "add :/usr/local/cuda/bin (including the ":") at the end of the"

        echo "###############################################################"
        echo "######## The above installation requires reboot or Logout user###############"
        echo "Reboot the system and run the same script"
        exit 1
    else    
        echo "######## Running POST Process of CUDA Installation ############"
        if [ -f verifyFlag ]; then
            cd /usr/local/cuda-9.0/samples
            sudo make
            cd /usr/local/cuda/samples/bin/x86_64/linux/release
            ./deviceQuery
        else    
            echo "Skipping, CUDA verfication"
        fi
    fi
}

function cuDNNInstall()
{
    echo "Download libcudnn7_7.0.5.15–1+cuda9.0_amd64.deb, libcudnn7-dev_7.0.5.15–1+cuda9.0_amd64.deb and 
    libcudnn7-doc_7.0.5.15–1+cuda9.0_amd64.deb from https://developer.nvidia.com/rdp/cudnn-download"
    echo "Need Nvidia Reg"
    read -r -p "Give a download path of cuDNN?[Y/N]" cuDNNPath
    pushd $cuDNNPath
    sudo dpkg -i libcudnn7*.deb
    popd
    #Configure the CUDA and cuDNN library paths
    echo 'export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/extras/CUPTI/lib64"' >> ~/.bashrc
    source ~/.bashrc
}

function verifyCuda()
{
    pip install --upgrade future --user
    pip install --upgrade tensorflow-gpu --user
    python -c "import tensorflow as tf; tf.enable_eager_execution(); print(tf.reduce_sum(tf.random_normal([1000, 1000])))"
}

function installOpenMPI()
{
    mkdir -p openmpi_temp
    wget "https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.0.tar.bz2" -O openmpi_temp
    tar -xvf openmpi_temp/openmpi-4.0.0.tar.bz2
    pushd openmpi_temp/openmpi-*
    read -r -p "Give a path to install openmpi/?[/home/Username/.openmpi]" openmpipath
    /configure --prefix="${openmpipath}"
    make
    read -r -p "Do you wanna Install?[Y/N]" response
	if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
	then
		sudo make install
	else
    	echo "Assume you will install manually"
	fi
    #Update the openmpi env variable
    echo export PATH="$PATH:$openmpipath/bin" >> /home/$USER/.bashrc
    echo export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$openmpipath/lib/" >> /home/$USER/.bashrc
}

function baiduAllreduceCompilation()
{
    mkdir DeepBench
    git clone https://github.com/baidu-research/baidu-allreduce.git DeepBench
    read -r -p "Give a openMPI lib path?[]" MPI_ROOT
    read -r -p "Give a CUDA Root path?[]" CUDA_ROOT
    make ${MPI_ROOT} ${CUDA_ROOT}
    echo "baiduAllreduceCompilation success"
}
function compileDeepBench()
{
    baiduAllreduceCompilation
    git clone https://github.com/baidu-research/DeepBench.git DeepBench
    pushd DeepBench/code/
    make ${CUDA_PATH} ${CUDNN_PATH} ${MPI_PATH} ${NCCL_PATH}
}

#MainStartsHere
echo "################# Deep Bench - Open source deep learning benchmark tool ####################"
read -r -p "Do you have Cuda and CuDNN installed?[Y/N]" response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    echo "Skipping, CUDA Installation"
    read -r -p "Do you have openMPI installed?[Y/N]" response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
    then
        echo "Skipping, OpenMPI Installation"
    else
        installOpenMPI
else
    cudaInstall
    cuDNNInstall
    verifyCuda
    #Remove the temp dir, After successfull installation
    rm -rf $CUR_PATH/temp
    read -r -p "Do you have openMPI installed?[Y/N]" response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
    then
        echo "Skipping, OpenMPI Installation"
    else
        installOpenMPI
fi

compileDeepBench
#Todo 
#NCCL installation