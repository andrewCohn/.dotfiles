# Estimate the number of blocks needed based on the used space
used_space=$(df -B1 --output=used /dev/nvme0n1p3 | tail -n 1 | awk '{print $1}')
block_size=4M
blocks_needed=$(expr $used_space / $(echo $block_size | sed 's/M/*1024*1024/'))

# Limit the size of the backup image to fit within the 500GB drive
max_blocks=$(( 500 * 1024 * 1024 * 1024 / $(echo $block_size | sed 's/M/*1024*1024/')))
if [ $blocks_needed -gt $max_blocks ]; then
    blocks_needed=$max_blocks
fi

# Clone the contents of /dev/nvme0n1 and compress it on-the-fly
echo "Cloning and compressing..."
dd if=/dev/nvme0n1 bs=4M count=$blocks_needed status=progress | gzip -c > /mnt/laptopBak_compressed.img.gz

echo "Backup completed."
