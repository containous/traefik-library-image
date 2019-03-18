#!/usr/bin/env bash

set -e
set -u # Exit on error when uninitialized variable

if [ $# -eq 0 ] ; then
	echo "Usage: ./update.sh <traefik tag or branch>"
	exit
fi

export DOLLAR='$'
export VERSION=$1
export ALPINE_VERSION=3.8
export WINDOWS_VERSION=sac2016

CERT_IMAGE="alpine:${ALPINE_VERSION}"
SCRIPT_DIRNAME_ABSOLUTEPATH="$(cd "$(dirname "$0")" && pwd -P)"
CERTS_DIR="${SCRIPT_DIRNAME_ABSOLUTEPATH}/certs"

# cd to the current directory so the script can be run from anywhere.
pushd "${SCRIPT_DIRNAME_ABSOLUTEPATH}"

# This function takes care of adding the Traefik Binary locally
# Based on 3 arguments: version, operating system and CPU's architecture
# The 4th argument is the directory where to put the binary
get_traefik_binary_from_platform() {
  local VERSION=$1
  local OS=$2
  local ARCH=$3
  local DESTINATION_DIR=$4

  [ -d "${DESTINATION_DIR}" ] || echo "ERROR: ${DESTINATION_DIR} does not exists"

	# https://github.com/containous/traefik/releases/download/v2.0.0-alpha1/traefik_v2.0.0-alpha1_freebsd_386.tar.gz

  local DESTINATION_FILE="${DESTINATION_DIR}/traefik"
  local DOWNLOAD_URL="https://github.com/containous/traefik/releases/download/${VERSION}/traefik_${VERSION}_${OS}_${ARCH}"

  pushd "${DESTINATION_DIR}"

	if [ "${OS}" == "windows" ]
  then
  	rm -f "${DESTINATION_FILE}.exe"
    DOWNLOAD_URL+=".zip"
	  wget -O "traefik_${VERSION}_${OS}_${ARCH}.zip" "${DOWNLOAD_URL}"
		unzip "traefik_${VERSION}_${OS}_${ARCH}.zip" traefik.exe

		rm -f "traefik_${VERSION}_${OS}_${ARCH}.zip"
  else
  	rm -f "${DESTINATION_FILE}"
		DOWNLOAD_URL+=".tar.gz"
	  wget -O "traefik_${VERSION}_${OS}_${ARCH}.tar.gz" "${DOWNLOAD_URL}"
		tar xzvf "traefik_${VERSION}_${OS}_${ARCH}.tar.gz" traefik
		rm -f "traefik_${VERSION}_${OS}_${ARCH}.tar.gz"
		chmod +x traefik
	fi

	popd
}

get_certs() {
    # Update the cert image.
    docker pull "${CERT_IMAGE}"

    # Fetch the latest certificates.
    ID="$(docker run -d ${CERT_IMAGE} sh -c "apk --update upgrade && apk add ca-certificates && update-ca-certificates")"
    docker logs -f "${ID}"
    docker wait "${ID}"

    # Update the local certificates.
    docker cp "${ID}:/etc/ssl/certs/ca-certificates.crt" "${CERTS_DIR}/"

    # Cleanup.
    docker rm -f "${ID}"
}

build_from_scratch() {
    FROM_SCRATCH_ARCH=(
        "amd64"
        "arm64"
        "armv7"
    )

    # Update the certificates.
    mkdir -p "${CERTS_DIR}"
    get_certs

    for ARCH in "${FROM_SCRATCH_ARCH[@]}" ; do
        rm -rf "${SCRIPT_DIRNAME_ABSOLUTEPATH}/scratch/${ARCH%v7}/"

         # Certificates
         rm -rf "${SCRIPT_DIRNAME_ABSOLUTEPATH}/scratch/${ARCH%v7}/certs/"
         mkdir -p "${SCRIPT_DIRNAME_ABSOLUTEPATH}/scratch/${ARCH%v7}/certs/"
         cp "${CERTS_DIR}/ca-certificates.crt" "${SCRIPT_DIRNAME_ABSOLUTEPATH}/scratch/${ARCH%v7}/certs/ca-certificates.crt"

         # Dockerfile
         envsubst < "${SCRIPT_DIRNAME_ABSOLUTEPATH}/scratch/tmpl.Dockerfile" > "scratch/${ARCH%v7}/Dockerfile"

         # Binary
         get_traefik_binary_from_platform \
          "${VERSION}" \
          "linux" \
          "${ARCH}" \
          "${SCRIPT_DIRNAME_ABSOLUTEPATH}/scratch/${ARCH%v7}" & # Run in background
    done
    # Since downloads are run in background, we have to wait for all
    # to finish (parallelized downloads)
    wait

    rm -rf ./certs
}


build_alternate_platform() {
  local PLATFORM_DIR="${SCRIPT_DIRNAME_ABSOLUTEPATH}/$1"
  [ -d "${PLATFORM_DIR}" ] # Directory for platform exists as absolute path

  rm -f "${PLATFORM_DIR}/Dockerfile"
  envsubst < "${PLATFORM_DIR}/tmpl.Dockerfile" > "${PLATFORM_DIR}/Dockerfile"
}

## From scratch
build_from_scratch

## Alpine
build_alternate_platform alpine

## Windows
# Download binary
get_traefik_binary_from_platform \
 "${VERSION}" \
 "windows" \
 "amd64" \
 "${SCRIPT_DIRNAME_ABSOLUTEPATH}/windows"
build_alternate_platform windows

echo "Done."
popd # Browse back to caller dirname
