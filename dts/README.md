# Device Tree Source

Device tree is a file that tells the Linux kernel some details on what hardware
is attached and how to access it. Editable files must be compiled into a binary
form and given to the bootloader.

Some helpful general information on device trees:

 * [Device tree usage](http://elinux.org/Device_Tree_Usage)
 * [Device tree for dummies video](https://www.youtube.com/watch?v=uzBwHFjJ0vU)
 * [Solving device tree issues](http://elinux.org/images/0/04/Dt_debugging_elce_2015_151006_0421.pdf)

## Board versions

We have device trees for these hardware versions:

 * `am335x-lgtc-wired.dtb` - wireless module and wired Ethernet placed (v1.1.2)
 * `am335x-lgtc-wireless.dtb` - only the wireless module placed (v1.1.3)

Compiled binary files are in the `dtb` subdirectory and are ready to use.
Unless you want to make changes you do not need to compile from source.

## Building

The `dtb` that was built using these steps was tested on the following kernels:

 * `4.4.30-ti-r64` (ships with the `bone-debian-8.6-seeed-iot-armhf-2016-11-06-4gb.img` image)
 * `4.4.87-ti-r121`

Requirements:

 * BeagleBoard Linux source (https://github.com/avian2/linux, branch sna-lgtc)

Prepare the kernel tree (run on the top of the kernel source):

    $ cp arch/arm/configs/bb.org_defconfig .config
    $ make ARCH=arm olddefconfig
    $ make ARCH=arm CROSS_COMPILE=arm-none-eabi- scripts

The build the `dtb` here with:

    $ make KERNEL=~/src/linux

Where `KERNEL` should point to the top of the kernel tree.

## Installation

Copy the appropriate `dtb` file into `/boot/dtbs/<version>/` on SNA-LGTC
(replace `<version>` with the kernel version you are currently using, e.g.
`4.4.87-ti-r121`). Change owner to `root`. The `/boot/uEnv.txt` file should
contain the name of the `dtb` file to use. For example:

    dtb=am335x-lgtc-wireless.dtb

The `dtb` file used must correspond to the board version you are using (see
*Board versions* above) or you will encounter problems.
