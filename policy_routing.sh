echo "5000 srvnet" >> /etc/iproute2/rt_tables

auto eth1
iface eth1 inet static
  address 192.168.1.2
  netmask 255.255.255.0
  post-up ip route add 192.168.1.0/24 dev eth1 src 192.168.1.2 table srvnet
  post-up ip route add default via 192.168.1.1 dev eth1 table srvnet
  post-up ip rule add from 192.168.1.0/24 table srvnet
  post-up ip rule add to 192.168.1.0/24 table srvnet


sudo systemctl restart networking
or
sudo ifdown eth1 && sudo ifup eth1

ip route show table srvnet
ip rule show
