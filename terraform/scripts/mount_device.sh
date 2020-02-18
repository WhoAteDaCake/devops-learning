sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard $DEVICE_ID
sudo mkdir -p $MOUNT_PATH
sudo mount -o discard,defaults $DEVICE_ID $MOUNT_PATH
sudo chmod a+w $MOUNT_PATH