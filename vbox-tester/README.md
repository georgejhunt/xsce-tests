### Virtual Box test System for IIAB
#### Overview
For each base operating system, download, or create a VM that can be quickly cloned, and tested. The script that is run on each VM is scripts/iiab.sh.
#### Setting up VirtualBox
* Install virtualbox
* Download virtualbox appliances from archive.org
  ```
  wget https://archive.org/download/debian-9-vbox-appliance.ova
  ```
#### Doing tests
* The top level script for testing is called "process.sh", which in turn calles cycle, which in turn cycles through the vm's (located in the vms directory)
* After the cycle script is finished, the logs containing the ansible outputs can be found in the output/<yymmdd> directory. 
