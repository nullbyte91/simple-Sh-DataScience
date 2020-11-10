# Compiling ROS cv_bridge with python3

# Main Starts from here
# Install dep
sudo apt-get install python3-pip python-catkin-tools python3-dev python3-numpy

# Install python dep
sudo pip3 install rospkg catkin_pkg

# Create a workspace
mkdir -p ~/cvbridge_build_ws/src
cd ~/cvbridge_build_ws/src

# Clone vision opencv repo
git clone -b noetic https://github.com/ros-perception/vision_opencv.git

# Configure and compile
cd ~/cvbridge_build_ws

catkin config -DPYTHON_EXECUTABLE=/usr/bin/python3 -DPYTHON_INCLUDE_DIR=/usr/include/python3.6m -DPYTHON_LIBRARY=/usr/lib/aarch64-linux-gnu/libpython3.6m.so

catkin config --install

catkin build cv_bridge && source install/setup.bash --extend

