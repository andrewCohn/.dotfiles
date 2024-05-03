#!/bin/bash

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Unmount the target partition if it's mounted
umount /dev/sda1
mount /dev/sda1 /mnt
# Clone the contents of /dev/nvme0n1 to /dev/sda1
echo "Cloning..."
dd if=/dev/nvme0n1 of=/mnt/laptopBak.img bs=4M status=progress

# Verify the backup
echo "Verifying backup..."
if dd if=/dev/nvme0n1 of=/mnt/laptopBak.img bs=4M iflag=fullblock | cmp /dev/nvme0n1 -; then
    echo "Backup verified successfully."
else
    echo "Backup verification failed."
fi

# Sync and exit
sync
echo "Clone completed. Your system is backed up to /dev/sda1."
