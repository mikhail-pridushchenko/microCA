#!/bin/bash
set -e

cd ca

openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out private/sub-ca.key
openssl req -new -config sub-ca.conf -out sub-ca.csr -key private/sub-ca.key
openssl ca -config root-ca.conf -in sub-ca.csr -out sub-ca.crt -extensions sub_ca_ext -batch
rm -f sub-ca.csr
