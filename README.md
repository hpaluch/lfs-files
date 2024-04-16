# Linux from Scratch files

Here are my experimental files for Linux from Scratch.

Use on your own risk!

Resources:
- https://github.com/hpaluch/hpaluch.github.io/wiki/LinuxFromScratch
- https://www.linuxfromscratch.org/

It is expected that you followed my wiki and:
- installed base system with ALFS
- also enable BLFS including GPM package (I will later build mc)

# Building packages Beyond LFS (BLFS)

It is expected that you will *carefully* copy content of `tree/` to your `/`.
When I make any change I can copy it back to git using `./copy_back_tree.sh` script.

Please see [tree/usr/src/packages-r12.1-42.log](tree/usr/src/packages-r12.1-42.log) for
my order of package builds.

As first you should download and unpack bootscripts, for example using:
```shell
cd /usr/src
mkdir bootscripts
cd bootscripts
curl -fLO https://anduin.linuxfromscratch.org/BLFS/blfs-bootscripts/blfs-bootscripts-20240209.tar.xz
tar xvf blfs-bootscripts-20240209.tar.xz
```

Current build order:

1. [tree/usr/src/unix-tree/make-unix-tree-2.1.1](tree/usr/src/unix-tree/make-unix-tree-2.1.1)
   (provides tree(1) command) - intentionally first build to ensure that everything works.
1. [tree/usr/src/openssh/make-openssh-9.6p1](tree/usr/src/openssh/make-openssh-9.6p1).
   After build you have to install service from bootscripts and configure sshd - see
   not at the end of build.
1. [tree/usr/src/dhcpcd/make-dhcpcd-10.0.6](tree/usr/src/dhcpcd/make-dhcpcd-10.0.6)
   After build you will have to install service from bootscripts and update your `ifconfig.eth0`
   to use DHCP client.

