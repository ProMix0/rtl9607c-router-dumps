This repository contains RTL9607C-based routers stock firmware dumps and scripts to dump/restore it

The device must run OpenWRT initramfs with `nand-utils` package and be accessible through network

The initramfs must define correct mtd partitions. You should detach UBI partitions before dump to ensure dump will be consistent

Example usage:

```
# To dump FW for future restoration and for examining by community
./dump.sh 192.168.0.100 RG-5520G
# Restore OEM FW if you want
./restore.sh 192.168.0.100 RG-5520G
```

Links:
* https://forum.openwrt.org/t/support-for-rtl9607c-rtl8198d-realtek-soc/240741
* https://github.com/openwrt/openwrt/pull/20064
* https://github.com/ProMix0/openwrt/tree/rtl9607c-dev

Your dumps are welcome

