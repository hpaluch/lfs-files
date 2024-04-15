# Here are my kernel configs

Please note that if you use specific config for different version
or kernel you may need to manually select some essential options.
Because when default value of config changes it will result in building
different version. 

I already encountered this  problem when I tried to use Linux 6.6.21-gentoo
configuration for plain 6.8.2 (LFS). I had to manually:
- enable Unix sockets (required for `udevd` in initrd) - `CONFIG_UNIX`
- enable devtmpfs options

Example usage:
```shell
tar xvf /sources/linux-6.8.2.tar.xz -C /usr/src
cp 6.8.2/hplfs_config /usr/src
cp /usr/src/hplfs_config /usr/src/linux-6.8.2/arch/x86/configs
cd /usr/src/linux-6.8.2
make hplfs_config
make menuconfig # finetune details
make -j`nproc` # build arch/x86_64/boot/bzImage
# TODO: cp kernel (make install will not work)
sudo make modules_install
# TODO: regenerate initramfs
# TODO: /boot/grub/grub.cfg
```

