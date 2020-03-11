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

# Install Intel Runtime
# Download : l_opencl_p_18.1.0.015.tgz from Intel download center
ARG RUNTIME=l_opencl_p_18.1.0.015.tgz
ARG INSTALL_DIR=/opt/intel
ARG TEMP_DIR=/tmp/opencl

RUN mkdir -p ${TEMP_DIR}
COPY ${RUNTIME} ${TEMP_DIR}

# Intel Runtime dep
RUN apt-get update && apt-get install -y --no-install-recommends \
    cpio 

RUN cd $TEMP_DIR && tar -xvf l_opencl_p_18.1.0.015.tgz && \
    cd l_opencl* && sed -i '10s/decline/accept/' silent.cfg && \
    bash install.sh -s silent.cfg 

RUN apt-get update && apt-get install -y --no-install-recommends \
    opencl-headers \
    clinfo 
