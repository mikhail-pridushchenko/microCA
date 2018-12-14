#!/bin/bash
set -e

cd ca

KERNEL_RELEASE="$(uname -r)"

if [[ "$KERNEL_RELEASE" =~ "ARCH" ]]
then
	cat root-ca.crt sub-ca.crt > /etc/ca-certificates/trust-source/anchors/pdk_vpn.pem
	trust extract-compat
elif $(which update-ca-certificates &> /dev/null)
then
	cp root-ca.crt sub-ca.crt /usr/local/share/ca-certificates/
	update-ca-certificates
fi
