#!/bin/sh

VPN_IPRANGE=${VPN_IPRANGE:-10.255.255.0/24}
HOSTIP_DOCKER=$(ip route | awk '/^default/ { print $3; }')

function ensure_tun_device {
    mkdir -p /dev/net
    if [ ! -e /dev/net/tun ]; then
        mknod /dev/net/tun c 10 200
    fi
}

function ensure_nat {
    iptables -t nat -C POSTROUTING -s $VPN_IPRANGE -o eth0 -j MASQUERADE || \
        iptables -t nat -I POSTROUTING -s $VPN_IPRANGE -o eth0 -j MASQUERADE

    for LOCALIP in $(echo $LOCAL_IPS | sed -r -e 's/[[:space:]]+/ /g' | tr ' ' '\n'); do
        iptables -t nat -C PREROUTING -i tun0 -s $VPN_IPRANGE -d $LOCALIP -j DNAT --to-destination $HOSTIP_DOCKER || \
            iptables -t nat -I PREROUTING -i tun0 -s $VPN_IPRANGE -d $LOCALIP -j DNAT --to-destination $HOSTIP_DOCKER
    done
}

function run {
    openvpn --config /etc/openvpn/server.conf
}

ensure_tun_device
ensure_nat
run
