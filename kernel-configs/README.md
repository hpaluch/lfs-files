# Here are my kernel configs

Please note that if you use specific config for different version
of kernel you may need to manually select some essential options.

I already encountered this problem when I tried to reuse Linux 6.6.21-gentoo
configuration for plain 6.8.2 (LFS). I had to manually:
- enable Unix sockets (required for `udevd` in initrd) - `CONFIG_UNIX`
- enable devtmpfs options
All of that was necessary because default values changed.

Example usage:
```shell
tar xvf /sources/linux-6.8.2.tar.xz -C /usr/src
cp 6.8.2/hplfs_defconfig /usr/src
cp /usr/src/hplfs_defconfig /usr/src/linux-6.8.2/arch/x86/configs
cd /usr/src/linux-6.8.2
make hplfs_defconfig
make menuconfig # finetune details
# use: "make savedefconfig" to generate new config as "defconfig" file
make -j`nproc` # build arch/x86_64/boot/bzImage
# cp kernel (make install will not work - it expects LILO or installkernel hook)
kver=$(< include/config/kernel.release)
echo $kver
# example output: 6.8.2-hplfs
sudo cp arch/x86_64/boot/bzImage /boot/vmlinuz-$kver
sudo make modules_install
sudo /usr/sbin/mkinitramfs $kver
sudo mv initrd.img-$kver /boot/
```

You have to also add entry to your `/boot/grub/grub.cfg` My example:

```
set default=0
set timeout=5

menuentry "LFS initrd, Linux 6.8.2-hplfs " {
  insmod part_gpt
  insmod ext2
  search --no-floppy --fs-uuid --set=root 8e5061e9-bbd5-4ee3-8306-bc3609846709
  linux  /boot/vmlinuz-6.8.2-hplfs root=UUID=8e5061e9-bbd5-4ee3-8306-bc3609846709 ro net.ifnames=0 rootdelay=3
  initrd /boot/initrd.img-6.8.2-hplfs
}

# old entries...
```

