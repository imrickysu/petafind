# PetaFind
A utility to simplify finding files in PetaLinux/Yocto

## General Usage

Source script functions into shell environment
```
source pf.sh
```

In most use cases, PetaLinux environment is setup before using petafind.
```
source <petalinux install dir>/settings64.sh
```


General usage
```
petafind <type> <keyword>
```
- type can be `recipe`, `config`, `root`, `tmp`, `u-boot`. More options would be added in the future. Type can be simplified to its first character, such as `recipe` to `r`
- keyword is the search keyword for this type.

Two common use cases that don't need keywords are simplied to one word command
- petaroot: cd to petalinux project root directory
- petatmp: print petalinux project tmp directory

## Examples
Find base recipes that relates to gstreamer.
```
$ petafind r "gstreamer*.bb"
--------------------------
petafind v0.1
--------------------------

Project Base: /xxx/petalinux_2018.2_proj

------ Project Metadata ------
* Project Version: 2018.2
* Project Family: zynqMP
* Project TMP: /tmp/petalinux_2018.2_proj-2019.01.02-05.29.31


------ Search Recipes ------

Searching gstreamer*.bb in project meta-user layer


Searching gstreamer*.bb in PetaLinux installation directory for aarch64
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/meta-petalinux/recipes-multimedia/gstreamer/gstreamer-vcu-examples_0.1.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/meta-openembedded/meta-multimedia/recipes-multimedia/gstreamer-0.10/gstreamer_0.10.36.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-plugins-bad_1.12.2.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-meta-base.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-libav_1.12.2.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-rtsp-server_1.12.2.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0_1.12.2.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-plugins-good_1.12.2.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-omx_1.12.2.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-plugins-base_1.12.2.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-plugins-ugly_1.12.2.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-python_1.12.2.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-vaapi_1.12.2.bb
```

Find all related recipes including bb and bbappends
```
$ petafind r "gstreamer*.bb*"
--------------------------
petafind v0.1
--------------------------

Project Base: /xxx/petalinux_2018.2_proj

------ Project Metadata ------
* Project Version: 2018.2
* Project Family: zynqMP
* Project TMP: /tmp/petalinux_2018.2_proj-2019.01.02-05.29.31


------ Search Recipes ------

Searching gstreamer*.bb* in project meta-user layer

/xxx/petalinux_2018.2_proj/project-spec/meta-user/recipes-multimedia/gstreamer/gstreamer1.0-plugins-bad_%.bbappend
/xxx/petalinux_2018.2_proj/project-spec/meta-user/recipes-multimedia/gstreamer/gstreamer1.0-plugins-base_%.bbappend
/xxx/petalinux_2018.2_proj/project-spec/meta-user/recipes-multimedia/gstreamer/gstreamer1.0-plugins-good_%.bbappend
/xxx/petalinux_2018.2_proj/project-spec/meta-user/recipes-multimedia/gstreamer/gstreamer1.0_%.bbappend
/xxx/petalinux_2018.2_proj/project-spec/meta-user/recipes-multimedia/gstreamer/gstreamer1.0-omx_%.bbappend

Searching gstreamer*.bb* in PetaLinux installation directory for aarch64

/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/meta-petalinux/recipes-multimedia/gstreamer/gstreamer-vcu-examples_0.1.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/meta-petalinux/recipes-multimedia/gstreamer/gstreamer1.0-omx_%.bbappend
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/meta-petalinux/recipes-multimedia/gstreamer/gstreamer1.0-plugins-good_%.bbappend
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/meta-petalinux/recipes-multimedia/gstreamer/gstreamer1.0-plugins-bad_%.bbappend
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/meta-petalinux/recipes-multimedia/gstreamer/gstreamer1.0-plugins-base_%.bbappend
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/meta-petalinux/recipes-multimedia/gstreamer/gstreamer1.0_%.bbappend
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/meta-openembedded/meta-multimedia/recipes-multimedia/gstreamer-0.10/gstreamer_0.10.36.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-plugins-bad_1.12.2.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-meta-base.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-libav_1.12.2.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-rtsp-server_1.12.2.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0_1.12.2.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-plugins-good_1.12.2.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-omx_1.12.2.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-plugins-base_1.12.2.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-plugins-ugly_1.12.2.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-python_1.12.2.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/core/meta/recipes-multimedia/gstreamer/gstreamer1.0-vaapi_1.12.2.bb
/opt/petalinux/2018.2/components/yocto/source/aarch64/layers/meta-qt5/recipes-multimedia/gstreamer/gstreamer1.0-plugins-bad_%.bbappend

```

Report config files in this project
```
$ petafind config
--------------------------
petafind v0.1
--------------------------

Project Base: /xxx/petalinux_2018.2_proj

------ Project Metadata ------
* Project Version: 2018.2
* Project Family: zynqMP
* Project TMP: /tmp/petalinux_2018.2_proj-2019.01.02-05.29.31


------ Project Configuration Files ------
* Project Config File: 
/xxx/petalinux_2018.2_proj/project-spec/configs/config

* Project Rootfs Config File: 
/xxx/petalinux_2018.2_proj/project-spec/configs/rootfs_config

* Project Rootfs Additional Config: 
/xxx/petalinux_2018.2_proj/project-spec/meta-user/recipes-core/images/petalinux-image.bbappend
- Note: Add recipes supported by Yocto but not listed in PetaLinux rootfs to IMAGE_INSTALL_append

* Project Final Kernel Config: 
/tmp/petalinux_2018.2_proj-2019.01.02-05.29.31/work-shared/plnx-zynqmp/kernel-build-artifacts/.config
```

Find U-boot configuration files
```
 $ petafind u-boot
--------------------------
petafind v0.1
--------------------------

Project Base: /xxx/petalinux_2018.2_proj

------ Project Metadata ------
* Project Version: 2018.2
* Project Family: zynqMP
* Project TMP: /tmp/petalinux_2018.2_proj-2019.01.02-05.29.31


------ U-boot Configuration Files ------
platform-top.h: /xxx/petalinux_2018.2_proj/project-spec/meta-user/recipes-bsp/u-boot/files/platform-top.h

```
