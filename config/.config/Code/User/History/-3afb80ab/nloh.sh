#!/bin/bash

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Parse command line parameter
if [ "$1" == "--power-off" ]; then
    POWER_OFF=true
else
    POWER_OFF=false
fi

# Clone the contents of /dev/nvme0n1 to /dev/sda1
rm /mnt/backup.log
touch /mnt/backup.log
umount /dev/sda1
mount /dev/sda1 /mnt

echo "Cloning and compressing..."
echo "Cloning and compressing...\n" >> /mnt/backup.log
dd if=/dev/nvme0n1 bs=4M status=progress | pigz > /mnt/laptopBak.img.gz

# Verify the backup
echo "Verifying backup..."
echo "Verifying backup...\n" > backup.log
if dd if=/dev/nvme0n1 bs=4M status=progress | pigz | cmp - /mnt/laptopBak.img.gz; then
    echo "Backup verified successfully."
    echo "Backup verified successfully.\n" >> /mnt/backup.log
else
    echo "Backup verification failed."
    echo "Backup verification failed.\n" >> /mnt/backup.log
fi

# Sync and exit
sync
echo "Clone completed and compressed. Your system is backed up to /dev/sda1."

# Power off if requested
if $POWER_OFF; then
    echo "Powering off..."
    poweroff
fi
