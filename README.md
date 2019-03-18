# PKI & Certificates

These commands wrap `easy-rsa`. To make it as comfortable as possible, the command
`./bin/easy-rsa` will build a docker container, install `easy-rsa` in that and then
invoke `easy-rsa` within that container. This removes the obligation to install
`easy-rsa` manually.

To get help regarding all available commands, simply run `./bin/easy-rsa`.

Note that all files (certificates, key files etc.) will be saved into a docker
volume that gets mounted from your host. So you will find all resulting files in
the folder `./volumes/certs/pki` on your host machine.

The steps that you most probably will want to run are the following:

## Create Certificate Authority (CA)
This should only be done once to initialize your CA.
1. Init PKI: `./bin/easy-rsa init-pki`
2. Build CA: `./bin/easy-rsa build-ca`
You can now find your CA's certificate in `./volumes/certs/pki/ca.crt`.

## Generate Certificate & DH for Server
This should be done once for each OpenVPN server that you're going to
run.
1. Generate Server Cert: `./bin/easy-rsa build-server-full server1 nopass`
2. Generate DH: `./bin/easy-rsa gen-dh`
You can now find your server's certificate relevant files:
- Key: `./volumes/certs/pki/private/server1.key`
- Cert: `./volumes/certs/pki/issued/server1.crt`
- Diffie-Hellman: `./volumes/certs/pki/dh.pem`

## Generate Certificate(s) for Client(s)
This should be done once for each client.
1. Generate Client Cert: `./bin/easy-rsa build-client-full client1`
You can now find your client's certificate files:
- Key: `./volumes/certs/pki/private/client1.key`
- Cert: `./volumes/certs/pki/issued/client1.crt`


# Server Configuration
You might want to adjust `./server/server.conf`, e.g. for adding routes etc.


# Running OpenVPN service
All necessary files for the VPN server (namely `./server/server.conf`, `ca.crt`, 
`dh.pem`, `private/serverX.key` and `issued/serverX.crt`) will be mounted into the
OpenVPN container. You may need to
adjust `docker-componse.yaml` regarding the latter two files, because those filenames
depend upon the server name you've passed into the invocation for creating your server
certificate (see above), thus
1. Adjust `docker-compose.yaml` regarding the volumes that mount `private/serverX.key`
   and `issued/serverX.crt`.
2. `docker-compose up -d`
This will expose & publish port 1194/udp to your host machine. This means that OpenVPN
clients can now establish an OpenVPN connection to your host machine.


# Configuring Client(s)
1. Copy `ca.crt`, `private/clientX.key` and `issued/clientX.crt` from `./volumes/certs/pki/`
   to your client.
2. Use your network software to configure an OpenVPN VPN. This depends on what software you
   use to do that.
