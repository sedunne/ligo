#  LigoVM

Ligo is a (very) rough PoC for working with the Virtualization.framework, for MacOS 11+.

## Considerations

Right now, Virtualization.framework or maybe the underlying virtualization system, seems to be incredibly picky on which kernels it will boot. Based on feedback from other projects, it seems very hit or miss, and at least in my case very few things seemed to want to boot. Eventually, I got the kernel and ramdisk from the cloud-image version of Ubuntu 18.04 working, and that is what was used for testing for the rest of the project. Some people had success building their own kernels/initrd, but given how the only success I've had is with an older kernel/release, I'm wondering if there's some incompatibility with newer kernels/macos virtualization. It also seemed like most people were trying this on the M1 Macs, and that may be adding another complication to what's consistently working.

The framework exclusively uses VirtIO devices, so make sure the kernel/initrd has support for that. 

Installing from an ISO is also not really just as easy as "attach and run". It's probably easier to use a pre-installed system image, and just attach that to the VM.

If you're also trying to use Ubuntu, you can (currently) get the disk IMG, vmlinuz-generic, and initrd-generic files [directly from Ubuntu](https://cloud-images.ubuntu.com/releases/bionic/release/).

## See Also
[SimpleVM](https://github.com/KhaosT/SimpleVM) and [vftool](https://github.com/evansm7/vftool) are other similar projects, and were especially helpful when trying to put things together.
