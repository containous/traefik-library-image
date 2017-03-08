#!/bin/sh

set -e

if [ $# -eq 0 ] ; then
	echo "Usage: ./update.sh <traefik tag or branch>"
	exit
fi

export VERSION=$1

# cd to the current directory so the script can be run from anywhere.
cd `dirname $0`

# Update the certificates.
echo "Updating certificates..."
./certs/update.sh

echo "Fetching and building traefik $VERSION..."
wget -O traefik https://github.com/containous/traefik/releases/download/$VERSION/traefik
chmod +x traefik
cp traefik alpine/

echo "Replace $VERSION in Dockerfiles..."
envsubst < Dockerfile.tmpl > Dockerfile
envsubst < alpine/Dockerfile.tmpl > alpine/Dockerfile

echo "Done."
