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

Examples
- find recipes that relates to gstreamer: `pf r "*gstreamer*.bb*"`
