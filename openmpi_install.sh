#To Do: Need to test on ubuntu 16.04
#Untested script
#!/bin/bash

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
echo export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$openmpipath/lib/"
>> /home/$USER/.bashrc