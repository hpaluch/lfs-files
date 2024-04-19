# Linux from Scratch files

Here are my experimental files for Linux from Scratch.

Use on your own risk!

Resources:
- https://github.com/hpaluch/hpaluch.github.io/wiki/LinuxFromScratch
- https://www.linuxfromscratch.org/

It is expected that you followed my wiki and:
- installed base system with ALFS (Automated Linux from scratch)
- also enabled BLFS builds including GPM package (it will be later used for `mc`)

TODO:
- `top` command has insane colors and other default settings
- probably using ` --disable-modern-top` (from https://gitlab.archlinux.org/archlinux/packaging/packages/procps-ng/-/blob/main/PKGBUILD?ref_type=heads)
  should help.


# Building packages Beyond LFS (BLFS)

It is expected that you will *carefully* copy content of `tree/` to your `/`.
When I make any change I can copy it back to git using `./copy_back_tree.sh` script.

Please see [tree/usr/src/packages-r12.1-42.log](tree/usr/src/packages-r12.1-42.log) for
my order of package builds.

As first you should download and unpack bootscripts (there is no build script, because
there is nothing to build), for example using:

```shell
cd /usr/src
mkdir bootscripts
cd bootscripts
curl -fLO https://anduin.linuxfromscratch.org/BLFS/blfs-bootscripts/blfs-bootscripts-20240209.tar.xz
tar xvf blfs-bootscripts-20240209.tar.xz
```

Current build order:

1. [tree/usr/src/unix-tree/make-unix-tree-2.1.1](tree/usr/src/unix-tree/make-unix-tree-2.1.1)
   provides tree(1) command - intentionally first trivial build to ensure that everything works.
1. [tree/usr/src/openssh/make-openssh-9.6p1](tree/usr/src/openssh/make-openssh-9.6p1).
   After build you have to install service from bootscripts and configure sshd - see
   note at the end of build.
1. [tree/usr/src/dhcpcd/make-dhcpcd-10.0.6](tree/usr/src/dhcpcd/make-dhcpcd-10.0.6)
   After build you will have to install service from bootscripts and update your `ifconfig.eth0`
   to use DHCP client.
1. [tree/usr/src/glib/make-glib-2.78.4](tree/usr/src/glib/make-glib-2.78.4) required
   for Midnight Commander. FIXME: it downloads pcre2 dependency on build (so it is not
   noted anywhere).
1. [tree/usr/src/mc/make-mc-4.8.31](tree/usr/src/mc/make-mc-4.8.31) Midnight
   Commander. Build with ncurses to avoid installing slang library.
1. [tree/usr/src/bubblewrap/make-bubblewrap-0.8.0](tree/usr/src/bubblewrap/make-bubblewrap-0.8.0)
   Bubblewrap - I plan to use it to build in network isolation (to avoid problem when GLib downloaded
   pcre2)

   Here is example how network isolation works (bind is required to find any files):
   ```shell
   $ bwrap --unshare-net --dev-bind / / /usr/sbin/ip l

   1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
      link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
   ```

   NOTE: that only `lo` (loopback) is visible...


