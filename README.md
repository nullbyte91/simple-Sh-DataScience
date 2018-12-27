# Simple Bash script's for Data Science

With Simple bash scripts can perform the installation/Configuration of many of the Data Science Tool, Lib and Application.

## List of contents

List of commands and application:

---
[aws_cli_configuration-amazon.sh](https://github.com/nullbyte91/Simple-Sh-DataScience/blob/master/aws_cli_configuration-amazon.sh) - Install AWS CLI and configure.

<b> Details:</b></br>
This script download, Install and configure:</br>
* Python 2 & Pip2 install if not installed
* AWS CLI (AWS Command line interface) install 
* AWS CLI Configuration

[deepBench_Deploy.sh - Only Nvidia Support](https://github.com/nullbyte91/Simple-Sh-DataScience/blob/master/deepBench_Deploy.sh) - Deploy DeepBench and get Hardware BenchMark for Deep Neural Network (Only Support Nvidia Based board)

<b> Details:</b></br>
This script download, Install and configure:</br>
* CUDA & cuDNN install if not installed
* OpenMPI install if not installed
* Compile baiduAllreduceCompilation
* Compile Deep Bench and generate Gemm, Convolutions and other bin.

[deepSpeech.sh](https://github.com/nullbyte91/Simple-Sh-DataScience/blob/master/deepSpeech.sh) - Deep Speeh auto script - Can setup deep Speech env, Deep Speech inference

<b> Details:</b></br>
This script supports Deep Speech Inference Setup, Deep Speech Inference and Deep Speech Training setup

This script download, Install and configure:</br>
* Python 2 & Pip2 install if not installed
* virtualenv install if not installed
* create virtualenv and activate
* deepSpeech pip install

<b>Note:</b>

We are activating the virtual env inside a bash script. So, We have run the deep speech script with source util.

```bash
source deepSpeech.sh
```

[git-openssl.sh](https://github.com/nullbyte91/Simple-Sh-DataScience/blob/master/git-openssl.sh) - Compile git package with openssl instead of gnutls

<b> Details:</b></br>
This script download, Install and configure:</br>
* Download git source
* Modify source code for openssl
* Compile git source
* Install generated dep package

[installCudaCuDNN.sh](https://github.com/nullbyte91/Simple-Sh-DataScience/blob/master/installCudaCuDNN.sh) - Install CUDA 9.0 and cuDNN 7.0

<b> Details</b></br>
This script download, Install and configure:</br>
* Install  CUDA 9.0 and cuDNN 7.0
* Configure env variable
* Verify the Cuda installation

[install_TensorFlow-CPU_with_pip.sh](https://github.com/nullbyte91/Simple-Sh-DataScience/blob/master/install_TensorFlow-CPU_with_pip.sh) - Install Tensorflow on Virtual env with dep.

[openmpi_install.sh](https://github.com/nullbyte91/Simple-Sh-DataScience/blob/master/openmpi_install.sh) - Install openmpi and configure

[ubuntu_datascience_env.sh](https://github.com/nullbyte91/Simple-Sh-DataScience/blob/master/ubuntu_datascience_env.sh) - Create a Data science env on Ubuntu system.

[docker.sh](https://github.com/nullbyte91/Simple-Sh-DataScience/blob/master/docker.sh) - Install docker and configure proxy if your behind corporate proxy

---