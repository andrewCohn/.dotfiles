#!/bin/bash

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Unmount the target partition if it's mounted
umount /dev/sda1

# Clone the contents of /dev/nvme0n1 to /dev/sda1
dd if=/dev/nvme0n1 of=/dev/sda1 bs=4M status=progress

# Sync and exit
sync
echo "Clone completed. Your system is backed up to /dev/sda1."
