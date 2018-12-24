#!/bin/bash
set -e

CSR_FILE="$1"
CRT_CN="$2"
IS_SERVER="${3:-yes}"

CRT_EXTENSION="server_ext"
case "$IS_SERVER" in
	1|Y|YES|y|yes)
		;;
	*)
		CRT_EXTENSION="client_ext"
esac

if [ -z "$CRT_CN" ]
then
	if [ "$CRT_EXTENSION" == "server_ext" ]
	then
		CRT_CN="vpn_server"
	else
		CRT_CN="vpn_client"
	fi
fi

if [[ -z "$CSR_FILE" ]]
then
	echo "CSR base file name is empty!"
	echo "Usage:"
	echo "$(basename $0) <CSR file name> <CN string> [<issue server certificate: yes (default)/no>]"
	exit 1
fi

# Ensure dummy CSR file exists
mkdir -p "$(dirname $CSR_FILE)"
touch "$CSR_FILE"

CSR_FILE=$(realpath "$CSR_FILE")
CRT_FILE_BASE=$(basename "$CSR_FILE" .csr)
CRT_DIR=$(dirname "$CSR_FILE")
CRT_FILE="$CRT_FILE_BASE".crt

cd ca

# Generate 
KEY_FILE="$CRT_FILE_BASE".key
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out private/"$KEY_FILE"
CSR_O="$(openssl x509 -noout -subject -in sub-ca.crt -nameopt multiline | grep '^[[:space:]]*organizationName *= ' | sed 's/^.*= //')"
CSR_C="$(openssl x509 -noout -subject -in sub-ca.crt -nameopt multiline | grep '^[[:space:]]*countryName *= ' | sed 's/^.*= //')"
openssl req -new -config sub-ca.conf -subj "/C=$CSR_C/O=$CSR_O/CN=vpn_server/" -key private/"$KEY_FILE" -out "$CSR_FILE"

openssl ca -config sub-ca.conf -in "$CSR_FILE" -out "$CRT_FILE" -extensions "$CRT_EXTENSION" -batch
cp "$CRT_FILE" private/"$KEY_FILE" "$CRT_DIR"/

rm -f "$CSR_FILE"
