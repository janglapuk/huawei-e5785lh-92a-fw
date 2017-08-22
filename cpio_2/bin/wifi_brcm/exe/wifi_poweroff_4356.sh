#!/system/bin/busybox sh

echo wifi_off 2000000000 > /sys/power/wake_lock



/system/bin/rmmod dhd
/system/bin/ecall wifi_power_off_4356


exit 0
