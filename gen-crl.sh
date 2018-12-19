#!/bin/bash
set -e
set -x

ACTIVE_CA=${1:-"sub"}

case "$ACTIVE_CA" in
	"sub"|"root")
		;;
	*)
		echo "Usage:"
		echo "$(basename $0) <CA to use: root|sub (default)>"
		exit 1
		;;
esac

cd ca
openssl ca -gencrl -config ${ACTIVE_CA}-ca.conf -out ${ACTIVE_CA}-ca.crl
