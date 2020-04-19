FROM ubuntu:16.04
LABEL maintainer="nullbyte.in@gmail.com"

ARG proxy

ENV http_proxy $proxy
ENV https_proxy $proxy

RUN echo "check_certificate = off" >> ~/.wgetrc
RUN echo "[global] \n\
trusted-host = pypi.python.org \n \
\t               pypi.org \n \
\t              files.pythonhosted.org" >> /etc/pip.conf

# >> START Install base software
# Basic update and Set the locale to en_US.UTF-8, because the Yocto build fails without any locale set.
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends locales ca-certificates &&  rm -rf /var/lib/apt/lists/*

# Locale set to something minimal like POSIX
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Exit when RUN get non-zero value
RUN set -e 

# Get basic packages
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        wget \
        git \
        python \
        python-dev \
        python-pip \
        python-wheel \
        python-numpy \
        python3 \
        python3-dev \
        python3-pip \
        python3-wheel \
        python3-numpy \
        python3-setuptools \
        libcurl3-dev  \
        gcc \
        sox \
        libsox-fmt-mp3 \
        htop \
        nano \
        swig \
        cmake \
        libboost-all-dev \
        zlib1g-dev \
        libbz2-dev \
        liblzma-dev \
        pkg-config \
        libsox-dev 

# Install pip
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

# # Install openvivoToolKit
ARG DOWNLOAD_LINK=http://registrationcenter-download.intel.com/akdlm/irc_nas/16612/l_openvino_toolkit_p_2020.2.120.tgz
ARG INSTALL_DIR=/opt/intel/openvino
ARG TEMP_DIR=/tmp/openvino_installer
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    cpio \
    sudo \
    lsb-release && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p $TEMP_DIR && cd $TEMP_DIR && \
    wget -c $DOWNLOAD_LINK && \
    tar xf l_openvino_toolkit*.tgz && \
    cd l_openvino_toolkit* && \
    sed -i 's/decline/accept/g' silent.cfg && \
    ./install.sh -s silent.cfg && \
    rm -rf $TEMP_DIR

RUN $INSTALL_DIR/install_dependencies/install_openvino_dependencies.sh

# OpenCV Fix
RUN pip3 install opencv-python
RUN apt-get update && apt-get install -y --no-install-recommends \ 
    libcanberra-gtk-module \
    libcanberra-gtk3-module

# Docker Read/Write permission Issue
ARG USER_ID
ARG GROUP_ID

RUN apt-get update && apt-get install -y --no-install-recommends sudo 

RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user &&  \
    echo user:user | sudo chpasswd && \
    usermod -aG sudo user
USER user

# OpenVINO Pre-trained model downloader dep
RUN pip3 install requests PyYAML

RUN echo "source /opt/intel/openvino/bin/setupvars.sh -pyver 3.5" >> ~/.bashrc