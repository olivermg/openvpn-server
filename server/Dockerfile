FROM alpine
RUN apk add openvpn && \
	mkdir -p /dev/net && \
	mknod /dev/net/tun c 10 200
EXPOSE 1194/udp
CMD openvpn --config /etc/openvpn/server.conf

