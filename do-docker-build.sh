#!/bin/bash
#
# NOTE: This assumes $CWD is the zcash repo.

set -eu

TAG="$(git rev-parse --abbrev-ref HEAD)"
CTX="${TMPDIR}/Docker-ctx-${TAG}"
DOCKERSRC="$(dirname "$(readlink -f "$0")")/Dockerfile"


set -x
[ -d "$CTX" ] && rm -rf "$CTX"
mkdir "$CTX"
cp "$DOCKERSRC" "${CTX}/Dockerfile"
cp -r "$(readlink -f .)" "${CTX}/zerocashd"

exec docker build --tag "$TAG" "$CTX"

