#!/bin/bash
set -e

cd ca

openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out private/root-ca.key
openssl req -new -config root-ca.conf -out root-ca.csr -key private/root-ca.key
openssl ca -selfsign -config root-ca.conf -in root-ca.csr -out root-ca.crt -extensions ca_ext -batch
rm -f root-ca.csr
