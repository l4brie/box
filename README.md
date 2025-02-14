# Box
A Bash wrapper script for management of chroot-based Linux distribution installations. It does require root permission on linux and it does not require root permission on android Termux application.

Box is not a virtual machine. This is container environment emulator based which utilitize proot, chroot and mount.

This script should never be run as root on android, But in Linux this need root / superuser permission.

# Synopsis
### Android
```bash
$ box [command or options]
```
### Linux
```bash
$ sudo box [command or options]
```

## See more with
### Android
```bash
$ box --help
```
### Linux
```bash
$ sudo box --help
```

# Installation

``` bash
$ sudo ./install
```
or
``` bash
$ sudo bash install
```

For android in Termux application just do the command without root permission.
``` bash
$ ./install
```

After you do the installation.
it will write program to /usr/bin/box.

# Uninstallation
``` bash
$ sudo rm /usr/bin/box
$ sudo rm -rf /var/lib/box
```

If you want to remove, run command above with root permission /usr/bin/box and /var/lib/box will be deleted.

# Notes

Program will store data to directory '/var/lib'
the rootfs will be placed on '/var/lib/box/root'

## Dont trust this program ?
--you can check all of the code--