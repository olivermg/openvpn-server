#!/bin/sh

mkdir -p /dev/net
if [ ! -e /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi

iptables -t nat -C POSTROUTING -s 10.255.255.0/24 -o eth0 -j MASQUERADE || \
    iptables -t nat -I POSTROUTING -s 10.255.255.0/24 -o eth0 -j MASQUERADE

openvpn --config /etc/openvpn/server.conf
