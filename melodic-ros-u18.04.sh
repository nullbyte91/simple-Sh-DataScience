#!/bin/bash

# Released under the MIT License (MIT)
# https://github.com/nullbyte91/Simple-Sh-DataScience/blob/master/LICENSE.md

# Title           : Melodic-ros-u18.04.sh
# Description     : A script to install ROS on ubuntu 18.04
# author		  : Jegathesan Shanmugam


function configure()
{
    sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
    sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

}

function basicUpdate()
{
    sudo apt update
}

function rosInstall()
{
    # Installing only base
    sudo apt install  -y ros-melodic-ros-base

    # Install ROS Desktop
    sudo apt install  -y ros-melodic-desktop

    # ROS dep
    sudo python3 -m pip install -U rosdep
    sudo rosdep init

    # And, Update them 
    rosdep update
       
}
# Main start from here
configure
basicUpdate
rosInstall

