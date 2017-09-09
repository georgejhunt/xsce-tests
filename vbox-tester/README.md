### Virtual Box test System for IIAB
#### Overview
For each base operating system, download, or create a VM that can be quickly cloned, and tested. The script that is run on each VM is scripts/iiab.sh.
#### Setting up VirtualBox
* Install virtualbox
* Download virtualbox appliances from archive.org
  ```
  wget https://archive.org/download/debian-9-vbox-appliance.ova
  wget https://archive.org/download/ubuntu-16.4-vbox-appliance.ova

  ```
* Install each of the appliance VM's into your vbox instance.
* You will need to put your public key into the vbox appliance, in /root/.ssh/authorized_keys, because all of the communication with the cloned VM is via ssh and scp.
* I find it easiest to run the tests as root, since the user on the VM needs to be root in order to actually install anything.
The ssh protocal assumes first that the user name is the same at both ends -- which means user name does not need to be specified.
#### Doing tests
* The top level script for testing is called "process.sh", which in turn calls cycle, which in turn cycles through the vm's (located in the ./vms/ directory)
* After the cycle script is finished, the logs containing the ansible outputs can be found in the output/<yymmdd> directory. 
