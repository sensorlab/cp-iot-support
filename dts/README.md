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

 * `am335x-cp-iot.dts`

Compiled binary files are in the `dtb` subdirectory and are ready to use.
Unless you want to make changes you do not need to compile from source.

## Building

The `dtb` that was built using these steps was tested on the following kernel:

 * `4.9.82-ti-r102` (ships with the `bone-debian-9.3-iot-armhf-2018-03-05-4gb.img` image)

Requirements:

 * BeagleBoard Linux source (https://github.com/matevzv/linux, branch cp-iot)

Prepare the kernel tree (run on the top of the kernel source):

    $ cp arch/arm/configs/bb.org_defconfig .config
    $ make ARCH=arm olddefconfig
    $ make ARCH=arm CROSS_COMPILE=arm-none-eabi- scripts

The build the `dtb` here with:

    $ make KERNEL=~/src/linux

Where `KERNEL` should point to the top of the kernel tree.

## Installation

Copy the appropriate `dtb` file into `/boot/dtbs/<version>/` on CP-IOT
(replace `<version>` with the kernel version you are currently using, e.g.
`4.9.82-ti-r102`). Change owner to `root`. The `/boot/uEnv.txt` file should
contain the name of the `dtb` file to use. For example:

    dtb=am335x-cp-iot.dtb

The `dtb` file used must correspond to the board version you are using (see
*Board versions* above) or you will encounter problems.
