#!/bin/sh

git clone https://github.com/clouds56/certtool && cd certtool
Intermediate_CN=Server; make $Intermediate_CN.intermediate.csr CN=$Intermediate_CN
# get $Intermediate_CN.intermediate.crt and $Intermediate_CN.intermediate.pem from ca Server
#Ocserv_CN = ocserv; make target CN=$Ocserv_CN CA=$Intermediate_CN.intermediate

pacman -S gnutls
Ocserv_CN=linode+ocserv
Ocserv_CN_=$(echo $Ocserv_CN|sed 's/+/ /g')
certtool --generate-privkey --outfile $Ocserv_CN.target.key && chmod og-rwx $Ocserv_CN.target.key
cat << _EOF_ >$Ocserv_CN.target.tmpl
cn = "$Ocserv_CN_"
dns_name = "linode"
ip_address = "45.79.150.187"
organization = "Clouds, Person."
unit = "Linode"
expiration_days = 400
signing_key
encryption_key #only if the generated key is an RSA one
tls_www_server
_EOF_
certtool --generate-request --load-privkey $Ocserv_CN.target.key --template $Ocserv_CN.target.tmpl --outfile $Ocserv_CN.target.csr
# TODO: block and wait on openssl altername issue
cat << _EOF_ >linode.cnf
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[ alt_names ]
DNS.0 = linode
IP = 45.79.150.187
_EOF_
make target CN=$Ocserv_CN CA=$Intermediate_CN.intermediate EXTFILE='-extfile linode.cnf'

# ocserv
sudo pacman -U ocserv-*.pkg.xz
