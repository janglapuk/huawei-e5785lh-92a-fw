#!/system/bin/busybox sh

mkdir bin
ln -s /system/bin/sh /bin/sh

/system/sbin/NwInquire &

busybox echo 0 > /proc/sys/net/netfilter/nf_conntrack_checksum

/etc/huawei_process_start
