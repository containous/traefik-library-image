#!/usr/bin/env bash

set -e

if [ $# -eq 0 ] ; then
	echo "Usage: ./update.sh <traefik tag or branch>"
	exit
fi

export VERSION=$1
export ALPINE_VERSION=3.6

CERT_IMAGE="alpine:edge"

# cd to the current directory so the script can be run from anywhere.
cd `dirname $0`

get_certs() {
    # Update the cert image.
    docker pull $CERT_IMAGE

    # Fetch the latest certificates.
    ID=$(docker run -d $CERT_IMAGE sh -c "apk --update upgrade && apk add ca-certificates && update-ca-certificates")
    docker logs -f ${ID}
    docker wait ${ID}

    # Update the local certificates.
    docker cp $ID:/etc/ssl/certs/ca-certificates.crt ./certs/

    # Cleanup.
    docker rm -f ${ID}
}

build_from_scratch() {
    FROM_SCRATCH_ARCH=(
        "amd64"
        "arm64"
        "arm"
    )

    # Update the certificates.
    mkdir -p ./certs
    get_certs

    for ARCH in "${FROM_SCRATCH_ARCH[@]}" ; do
        rm -rf "./scratch/${ARCH}/"

         # Certificates
         rm -rf "./scratch/${ARCH}/certs/"
         mkdir -p "./scratch/${ARCH}/certs/"
         cp ./certs/ca-certificates.crt "./scratch/${ARCH}/certs/ca-certificates.crt"

         # Binary
         rm -f ./scratch/${ARCH}/traefik
         wget -O ./scratch/${ARCH}/traefik https://github.com/containous/traefik/releases/download/$VERSION/traefik_linux-${ARCH}
         chmod +x ./scratch/${ARCH}/traefik

         # Dockerfile
         envsubst < scratch/tmpl.Dockerfile > scratch/${ARCH}/Dockerfile
    done

    rm -rf ./certs
}

build_alpine() {

    ALPINE_ARCH=(
        "amd64:alpine"
        "arm64:arm64v8/alpine"
        "arm:arm32v6/alpine"
    )

    for ARCH_ENTRY in "${ALPINE_ARCH[@]}" ; do
        ARCH="${ARCH_ENTRY%%:*}"

        export ALPINE_IMAGE="${ARCH_ENTRY##*:}"
        export TRAEFIK_BINARY="traefik_linux-${ARCH}"

        rm -rf "./alpine/${ARCH}/"
        mkdir -p "./alpine/${ARCH}/"

        cp ./alpine/entrypoint.sh "./alpine/${ARCH}/"

        envsubst < alpine/tmpl.Dockerfile > alpine/${ARCH}/Dockerfile
    done
}

## From scratch
build_from_scratch

## Alpine
build_alpine

echo "Done."
