#!/bin/bash
set -e

CA_DOMAIN="$1"
CA_CN="$2"

if [ -z "$CA_DOMAIN" -o -z "$CA_CN" ]
then
	echo "Either CA domain or name are empty!"
	echo "Usage:"
	echo "$0 <ca.domain> <ca.cn>"
	exit 1
fi

cp root-ca.conf sub-ca.conf ca/
cd ca

sed -i -e "s|EXAMPLE_DOMAIN|$CA_DOMAIN|" -e "s|EXAMPLE_dev|$CA_CN|" root-ca.conf
sed -i -e "s|EXAMPLE_DOMAIN|$CA_DOMAIN|" -e "s|EXAMPLE_dev|$CA_CN|" sub-ca.conf
