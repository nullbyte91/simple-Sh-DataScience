#!/bin/bash

# Copyright (c) 2018 Jegathesan Shanmugam
# Released under the MIT License (MIT)
# https://github.com/nullbyte91/Simple-Sh-DataScience/blob/master/LICENSE.md

# Title           : docker.sh
# Description     : This script to install opencv 3.4 on ubuntu 16.04
# author		  : Jegathesan Shanmugam

cvVersion="3.4"

function systemUpdate()
{
    sudo apt -y update
    sudo apt -y upgrade
}

function installSystemDep()
{
    sudo apt -y remove x264 libx264-dev
    sudo apt -y install build-essential checkinstall cmake pkg-config yasm
    sudo apt -y install git gfortran
    sudo apt -y install libjpeg8-dev libjasper-dev libpng12-dev
    sudo apt -y install libtiff5-dev
    sudo apt -y install libtiff-dev
    sudo apt -y install libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev
    sudo apt -y install libxine2-dev libv4l-dev
    sudo apt -y install libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
    sudo apt -y install libgtk2.0-dev libtbb-dev qt5-default
    sudo apt -y install libatlas-base-dev
    sudo apt -y install libfaac-dev libmp3lame-dev libtheora-dev
    sudo apt -y install libvorbis-dev libxvidcore-dev
    sudo apt -y install libopencore-amrnb-dev libopencore-amrwb-dev
    sudo apt -y install libavresample-dev
    sudo apt -y install x264 v4l-utils
    sudo apt -y install libprotobuf-dev protobuf-compiler
    sudo apt -y install libgoogle-glog-dev libgflags-dev
    sudo apt -y install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen
}

function videolibFix()
{
    pushd /usr/include/linux
    sudo ln -s -f ../libv4l1-videodev.h videodev.h
    popd
}

function intellPythonLib()
{
    sudo apt -y install python3-dev python3-pip python3-venv
    sudo -H pip3 install -U pip numpy
    sudo apt -y install python3-testresources
}

function createOpenCVVirtEnv(){
    pushd ~/
    python3 -m venv openCV-"$cvVersion"-py3
    source openCV-"$cvVersion"-py3/bin/activate
    pip install wheel numpy scipy matplotlib scikit-image scikit-learn ipython dli
    deactivate
    popd
}

function downloadSource()
{
    pushd ~/
    git clone https://github.com/opencv/opencv.git
    cd opencv
    git checkout $cvVersion
    cd ..
 
    git clone https://github.com/opencv/opencv_contrib.git
    cd opencv_contrib
    git checkout $cvVersion
    cd ..
}

function compileSource()
{
    pushd ~/opencv
    mkdir -p build
    cd build
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
            -D CMAKE_INSTALL_PREFIX=/usr/local \
            -D INSTALL_C_EXAMPLES=ON \
            -D INSTALL_PYTHON_EXAMPLES=ON \
            -D WITH_TBB=ON \
            -D WITH_V4L=ON \
            -D OPENCV_PYTHON3_INSTALL_PATH=$cwd/OpenCV-$cvVersion-py3/lib/python3.5/site-packages \
            -D WITH_QT=ON \
            -D WITH_OPENGL=ON \
            -D WITH_OPENCL=ON \
            -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
            -D BUILD_EXAMPLES=ON ..
    make -j6
    sudo make install 
    sudo ldconfig
}

# Main starts from here
systemUpdate
installSystemDep
videolibFix
intellPythonLib
createOpenCVVirtEnv
downloadSource
compileSource

