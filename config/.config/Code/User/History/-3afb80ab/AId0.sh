# Estimate the number of blocks needed based on the used space
used_space=$(df -B1 --output=used /dev/nvme0n1p3 | tail -n 1)
block_size=4M
blocks_needed=$(( $used_space / $block_size ))

# Limit the size of the backup image to fit within the 500GB drive
max_blocks=$(( 500 * 1024 * 1024 * 1024 / $block_size ))
if [ $blocks_needed -gt $max_blocks ]; then
    blocks_needed=$max_blocks
fi

# Clone the contents of /dev/nvme0n1 to an uncompressed image file
echo "Cloning..."
dd if=/dev/nvme0n1 of=/mnt/laptopBak.img bs=4M count=$blocks_needed status=progress

# Compress the image file using gzip
echo "Compressing..."
gzip -f /mnt/laptopBak.img

# Rename the compressed image file to indicate it is compressed
mv /mnt/laptopBak.img.gz /mnt/laptopBak_compressed.img.gz

echo "Backup completed."
