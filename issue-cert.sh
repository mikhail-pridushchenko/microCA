#!/bin/bash
set -x
set -e

CSR_FILE="$1"
IS_SERVER="${2:-'no'}"

if [[ -z "$CSR_FILE" ]]
then
	echo "CSR base file name is empty!"
	echo "Usage:"
	echo "$(basename $0) <CSR file name>"
	exit 1
fi

# Ensure dummy CSR file exists
mkdir -p "$(dirname $CSR_FILE)"
touch "$CSR_FILE"

CSR_FILE=$(realpath "$CSR_FILE")
CRT_FILE_BASE=$(basename "$CSR_FILE" .csr)
CRT_DIR=$(dirname "$CSR_FILE")
CRT_FILE="$CRT_DIR"/"$CRT_FILE_BASE".crt

cd ca

# Generate 
KEY_FILE="$CRT_DIR"/"$CRT_FILE_BASE".key
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out "$KEY_FILE"
CSR_O="$(openssl x509 -noout -subject -in sub-ca.crt -nameopt multiline | grep '^[[:space:]]*organizationName *= ' | sed 's/^.*= //')"
CSR_CN="$(openssl x509 -noout -subject -in sub-ca.crt -nameopt multiline | grep '^[[:space:]]*countryName *= ' | sed 's/^.*= //')"
openssl req -new -config sub-ca.conf -subj "/C=$CSR_CN/O=$CSR_O/CN=vpn_server/" -key "$KEY_FILE" -out "$CSR_FILE"

CRT_EXTENSION="client_ext"
case "$IS_SERVER" in
	"1"|"Y"|"YES"|"y"|"yes")
		CRT_EXTENSION="server_ext"
esac

openssl ca -config sub-ca.conf -in "$CSR_FILE" -out "$CRT_FILE" -extensions "$CRT_EXTENSION" -batch

rm -f "$CSR_FILE"
