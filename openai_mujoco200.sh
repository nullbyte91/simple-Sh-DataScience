# A script to install openai gym and mujoco200
# Test Env - Ubuntu 18.04

# Install dep
sudo apt install libosmesa6-dev libgl1-mesa-glx libglfw3 libglew-dev

echo "export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libGLEW.so" >> /home/nullbyte/.bashrc

# Download mujoco200 
wget https://www.roboti.us/download/mujoco200_linux.zip
unzip mujoco200_linux.zip
mkdir -p ~/.mujoco/
cp -rf mujoco200_linux ~/.mujoco/mujoco200/
# You have to copy the key to ~/.mujoco/ manually

echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/.mujoco/mujoco200/bin/" >> /home/nullbyte/.bashrc

# Install openAI Gym
git clone https://github.com/openai/gym.git
cd gym
pip install -e .

python3 -c "import mujoco_py; import gym"
