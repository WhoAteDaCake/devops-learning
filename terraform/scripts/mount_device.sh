#!/bin/bash
set -e
FULL_DEVICE_ID=/dev/disk/by-id/google-$DEVICE_ID
sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard $FULL_DEVICE_ID
sudo mkdir -p $MOUNT_PATH
sudo mount -o discard,defaults $FULL_DEVICE_ID $MOUNT_PATH
sudo chmod a+w $MOUNT_PATH