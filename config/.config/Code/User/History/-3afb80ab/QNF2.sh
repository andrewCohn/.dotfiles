#!/bin/bash

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi


# Clone the contents of /dev/nvme0n1 to /dev/sda1
echo "Cloning and compressing..."
dd if=/dev/nvme0n1 bs=4M status=progress| gzip > /mnt/laptopBak.img.gz

# Verify the backup
echo "Verifying backup..."
if dd if=/dev/nvme0n1 bs=4M status=progress| gzip | cmp - /mnt/laptopBak.img.gz; then
    echo "Backup verified successfully."
else
    echo "Backup verification failed."
fi

# Sync and exit
sync
echo "Clone completed and compressed. Your system is backed up to /dev/sda1."
