ps > /var/exportinfo/ps
cat /proc/meminfo >/var/exportinfo/meminfo
ifconfig >/var/exportinfo/ifconfig
netstat -a >/var/exportinfo/netstat
top -n 1 >/var/exportinfo/cpuinfo

cat /proc/proc_user_umts >/var/exportinfo/proc_user_umts
atcmd newcpin display >/var/exportinfo/atcmd_newcpin
atcmd ati display   >/var/exportinfo/atcmd_ati
atcmd dialmode display >/var/exportinfo/atcmd_dialmode

cat /proc/partitions >/var/exportinfo/partitions
cat /proc/proc_user_usbdevs >/var/exportinfo/proc_user_usbdevs
cat /proc/proc_user_printer >/var/exportinfo/proc_user_printer
cat /etc/printers.ini >/var/exportinfo/printers.ini
cat /var/ftp/bftpd.conf >/var/exportinfo/bftpd.conf
cat /var/ftp/ftpdpassword >/var/exportinfo/ftpdpassword
cat /var/samba/secrets.tdb >/var/exportinfo/secrets.tdb
cat /var/samba/smb.conf >/var/exportinfo/smb.conf
cat /var/samba/smbpasswd >/var/exportinfo/smbpasswd
cat /etc/cups/printers.conf >/var/exportinfo/printers.conf

ip rule > /var/exportinfo/ip_rule
ip -6 rule > /var/exportinfo/ip6_rule
ip route  > /var/exportinfo/ip_route
ip -6 route > /var/exportinfo/ip6_route
ip -6 n  > /var/exportinfo/ip6_n
ip maddr > /var/exportinfo/ip_maddr
ip tunnel > /var/exportinfo/ip_tunnel
ip -6 maddr > /var/exportinfo/ip6_maddr
ip -6 tunnel show > /var/exportinfo/ip6_tunnel
ip mroute > /var/exportinfo/ip_mroute
ip -6 mroute > /var/exportinfo/ip6_mroute
dns test server > /var/exportinfo/dns_test_server
dns test resident > /var/exportinfo/dns_test_resident
dns test redirect > /var/exportinfo/dns_test_redirect
dns test cache > /var/exportinfo/dns_test_cache
dhcps test show > /var/exportinfo/dhcps_test_show
ls var/wan/ > /var/exportinfo/ls_var_wan
ls var/radvd/ > /var/exportinfo/ls_var_radvd
ls var/dhcp/dhcp6s/ > /var/exportinfo/ls_var_dhcp6s
cat var/dhcp/dhcp6s/dhcp6sdefaultbr0.conf  > /var/exportinfo/dhcp6sdefaultbr0.conf
cat var/radvd/radvdbr0.conf > /var/exportinfo/radvdbr0.conf
ls var/dhcp/dhcps/ > /var/exportinfo/ls_var_dhcps
cat var/dhcp/dhcps/neighbors_new  > /var/exportinfo/neighbors_new
arp -a > /var/exportinfo/arp_a
ipcheck test show  > /var/exportinfo/ipcheck_test_show

iptables -nvL >/var/exportinfo/iptables
iptables -t nat -nvL>/var/exportinfo/iptables_nat
iptables -t mangle -nvL>/var/exportinfo/iptables_mangle

ip6tables -nvL >/var/exportinfo/ip6tables
ip6tables -t mangle -nvL >/var/exportinfo/ip6tables_mangle
ebtables -L --Lc >/var/exportinfo/ebtables
ebtables -t broute -L --Lc >/var/exportinfo/ebtables_broute
ebtables -t nat -L --Lc >/var/exportinfo/ebtables_nat

brctl show >/var/exportinfo/brctl_show
brctl showmacs br0 >/var/exportinfo/brctl_showmacs_br0
brctl showigmpsnooping >/var/exportinfo/brctl_showigmpsnooping
brctl showmldsnooping >/var/exportinfo/brctl_showmldsnooping
brctl showstp >/var/exportinfo/brctl_showstp

cat proc/net/nf_conntrack >/var/exportinfo/nf_connstrack

cat /var/fon/fon_mac  >/var/exportinfo/fon_mac
cat /var/fon/fon_keyword >/var/exportinfo/fon_keyword
cat /var/fon/fon_device >/var/exportinfo/fon_device
cat /var/fon_radius_ip >/var/exportinfo/fon_radius_ip
cat /var/fon/fon_revision >/var/exportinfo/fon_revision
cat /var/fon/fon_version >/var/exportinfo/fon_version
cat /var/fon/fon_device  >/var/exportinfo/fon_device
cat /var/fon/fon_dhcpserver >/var/exportinfo/fon_dhcpserver
cat /var/fon/chilli.conf >/var/exportinfo/chilli.conf
cat /var/fon/fonsmcd.conf >/var/exportinfo/fonsmcd.conf
cat /var/fon/radconfig >/var/exportinfo/radconfig
cat /var/fon/fon.conf >/var/exportinfo/fon.conf
cat /var/fon/fon_status >/var/exportinfo/fon_status
cat /etc/init.d/chill >/var/exportinfo/fon_chill
cat /etc/init.d/fonsmcd >/var/exportinfo/fonsmcd

tc -s qdisc show dev imq0 >/var/exportinfo/qos_qdisc_imq0
tc -s qdisc show dev imq1 >/var/exportinfo/qos_qdisc_imq1
tc -s qdisc show dev imq2 >/var/exportinfo/qos_qdisc_imq2
tc -s qdisc show dev imq3 >/var/exportinfo/qos_qdisc_imq3
tc -s qdisc show dev imq4 >/var/exportinfo/qos_qdisc_imq4
tc -s class show dev imq0 >/var/exportinfo/qos_class_imq0
tc -s class show dev imq2 >/var/exportinfo/qos_class_imq2
tc -s class show dev imq4 >/var/exportinfo/qos_class_imq4