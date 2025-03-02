#!/bin/bash
mkfs -t ext4 /dev/xvdf
mkdir /mnt/my-data
mount /dev/xvdf /mnt/my-data
echo "/dev/xvdf /mnt/my-data ext4 defaults,nofail 0 2" >> /etc/fstab