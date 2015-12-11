#!/bin/bash
#
# NOTE: This assumes $CWD is the zcash repo.

set -eu

if [ $# -eq 1 ]
then
    cd "$1"
elif [ $# -gt 1 ]
then
    cat <<EOF
Usage: $0 [ PATH_TO_ZCASH_REPO ]

If no path is given, the current working directory is assumed.
EOF
    exit 1
fi

if ! git remote -v | grep -q 'Electric-Coin-Company/zerocashd'
then
    echo "WARNING: $CWD does not seem like a zcash repo based on grepping git remote."
    exit 2
fi

TAG="$(git rev-parse --abbrev-ref HEAD)@$(git rev-parse HEAD | head -c 6)"
CTX="${TMPDIR:-/tmp}/Docker-ctx-${TAG}"
DOCKERSRC="$(dirname "$(readlink -f "$0")")/Dockerfile"


echo "===***=== Creating docker context: $CTX ===***==="
if [ -d "$CTX" ]
then
    echo "Removing old docker context: $CTX"
    rm -rf "$CTX"
fi

mkdir -v "$CTX"
cp -v "$DOCKERSRC" "${CTX}/Dockerfile"
rsync --recursive --exclude '.git' "$(readlink -f .)/" "${CTX}/zerocashd"

echo "===***=== Building Docker image $TAG ===***==="
docker build --tag "$TAG" "$CTX"

echo "===***=== Running Docker image $TAG ===***==="
exec docker run "$TAG"

