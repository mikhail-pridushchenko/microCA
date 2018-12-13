#!/bin/bash

CSR_FILE="$1"

if [ -z "$CSR_FILE" ]
then
	echo "CSR base file name is empty!"
	echo "Usage:"
	echo "$(basename $0) <CSR file name>"
	exit 1
fi

CSR_FILE=$(realpath "$CSR_FILE")
CRT_FILE_BASE=$(basename "$CSR_FILE" .csr)

cd ca
openssl ca -config ../sub-ca.conf -in "$CSR_FILE" -out "$CRT_FILE_BASE".crt -extensions client_ext -batch
mv "$CRT_FILE_BASE".crt "$(dirname $CSR_FILE)/"
