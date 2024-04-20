# Linux from Scratch files

Here are my experimental files for Linux from Scratch.

Use on your own risk!

Resources:
- https://github.com/hpaluch/hpaluch.github.io/wiki/LinuxFromScratch
- https://www.linuxfromscratch.org/

It is expected that you followed my wiki and:
- installed base system with ALFS (Automated Linux from scratch)
- also enabled BLFS builds including GPM package (it will be later used for `mc`)

# Building packages Beyond LFS (BLFS)

It is expected that you will *carefully* copy content of `tree/` to your `/`.
When I make any change I can copy it back to git using `./copy_back_tree.sh` script.

Please see [tree/usr/src/packages-r12.1-42.log](tree/usr/src/packages-r12.1-42.log) for
my order of package builds. Notice already one mistake: I build GLib2 without installed
PCRE2 - it downloaded its own copy of PCRE2 itself...

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
1. [tree/usr/src/procps-ng/make-procps-ng-4.0.4](tree/usr/src/procps-ng/make-procps-ng-4.0.4)
   Rebuild "normal" 'top' command instead of awful 'modern' variant. Tip comes from
   Arch Linux: https://gitlab.archlinux.org/archlinux/packaging/packages/procps-ng/-/blob/main/PKGBUILD?ref_type=heads
1. [tree/usr/src/pcre2/make-pcre2-10.42](tree/usr/src/pcre2/make-pcre2-10.42)
   PCRE2 library, required for GLib (which is required for MC). WARNING!
   Without PCRE2 library the GLib will attempt to download PCRE2 itself (!)

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

   NOTE: There are also other ways how to block DNS - for example temporarily comment out all `namserver` entries 
   in `/etc/resolv.conf` and run build. However direct IP address connection (or DoH - DNS Over Https
   will still work - without bwrap).

1. [tree/usr/src/glib/make-glib-2.78.4](tree/usr/src/glib/make-glib-2.78.4) required
   for Midnight Commander.
1. [tree/usr/src/mc/make-mc-4.8.31](tree/usr/src/mc/make-mc-4.8.31) Midnight
   Commander. Build with ncurses to avoid installing slang library.

