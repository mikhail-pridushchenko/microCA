#!/bin/bash
set -e
set -x

CERT_FILE_ARG="$1"
if [ -z "$CERT_FILE_ARG" ]
then
	echo "Usage:"
	echo "$(basename $0) <certificate file path>"
	exit 1
fi

CERT_FILE="$CERT_FILE_ARG"

if [ ! -e "$CERT_FILE" ]
then
	CERT_FILE="$(basename $CERT_FILE)"
	if [ ! -e ca/"$CERT_FILE" ]
	then
		echo "$CERT_FILE_ARG is absent even in CA subdirectory"
		exit 2
	fi
fi

cd ca
openssl ca -config sub-ca.conf -revoke "$CERT_FILE"
