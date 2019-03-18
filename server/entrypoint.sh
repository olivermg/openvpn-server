#!/bin/sh

mkdir -p /dev/net
if [ ! -e /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi

openvpn --config /etc/openvpn/server.conf
