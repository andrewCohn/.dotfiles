# Estimate the number of blocks needed based on the used space
used_space=$(du -s -B 1 /dev/nvme0n1p3 | cut -f 1)
block_size=$((4 * 1024 * 1024))  # 4M in bytes
blocks_needed=$((used_space / block_size))

# Limit the size of the backup image to fit within the 500GB drive
max_blocks=$((500 * 1024 * 1024 * 1024 / block_size))
if [ $blocks_needed -gt $max_blocks ]; then
    blocks_needed=$max_blocks
fi

# Clone the contents of /dev/nvme0n1 and compress it on-the-fly
echo "Cloning and compressing..."
dd if=/dev/nvme0n1 bs=$block_size count=$blocks_needed status=progress | gzip -c > /mnt/laptopBak_compressed.img.gz

echo "Backup completed."
