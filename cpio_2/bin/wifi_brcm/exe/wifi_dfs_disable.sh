#!/system/bin/busybox sh

/system/bin/wifi_brcm/exe/wl radarthrs 0x6c0 0xe0 0x6c0 0xe0 0x6c0 0xe0 0x6c0 0xe0 0x6c0 0xe0 0x6c0 0xe0
/system/bin/wifi_brcm/exe/wl dfs_ism_monitor 1
exit 0
