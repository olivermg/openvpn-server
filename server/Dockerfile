FROM alpine:3.9
RUN apk add openvpn
EXPOSE 1194/udp
COPY ./entrypoint.sh /entrypoint.sh
CMD /entrypoint.sh
