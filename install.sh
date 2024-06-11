#!/bin/sh

set -e -u -x

BASE_IMAGE="$1"

mkdir -v /install
mkdir -v /install/sbin
mkdir -v /install/lib

cp -av /exitpoint*.sh /install/
chmod -v +x /install/*.sh

case "$BASE_IMAGE" in
  alpine*)
    apk add tini
    cp /sbin/tini /install/sbin/tini
    ;;
  busybox*)
    # Get the statically compiled version of tini
    apk add dpkg jq
    arch="$(dpkg --print-architecture | rev | cut -d- -f1 | rev)"
    TINI_VERSION="$(
      curl -sL http://api.github.com/repos/krallin/tini/git/refs/tags \
        jq -crM '.[].ref' | sed -e 's|refs/tags/||' | sort -V | tail -1
    )"
    TINI_BASE=https://github.com/krallin/tini/releases/download
    cd /install/sbin
    wget "$TINI_BASE/$TINI_VERSION/tini-static-muslc-$arch" -O tini \
      || wget "$TINI_BASE/$TINI_VERSION/tini-static-$arch" -O tini
    chmod +x tini
    ;;
  *)
    echo "Unknown base image $BASE_IMAGE"
    ;;
esac

