#!/bin/bash
#
# NOTE: This assumes $CWD is the zcash repo.

set -eu

ZCASH_SRC='.'

TAG="$(git rev-parse --abbrev-ref HEAD)@$(git rev-parse HEAD | head -c 6)"
CTX="${TMPDIR:-/tmp}/Docker-ctx-${TAG}"
DOCKERSRC="$(dirname "$(readlink -f "$0")")/Dockerfile"


if [ -d "$CTX" ]
then
    echo "Removing old docker context: $CTX"
    rm -rf "$CTX"
fi

echo "===***=== Creating docker context: $CTX ===***==="
mkdir -v "$CTX"
cp -v "$DOCKERSRC" "${CTX}/Dockerfile"
rsync --recursive --exclude '.git' "$(readlink -f .)/" "${CTX}/zerocashd"

echo "===***=== Building Docker image $TAG ===***==="
docker build --tag "$TAG" "$CTX"

echo "===***=== Running Docker image $TAG ===***==="
exec docker run "$TAG"

