#!/bin/sh
exec >&2
set -eu

username="$1"
groupname="$2"
appdir="$3"
srcdir="$(cat DIBS_DIR_SRC)"
packdir="$(cat DIBS_DIR_PACK)"

rm -rf "$appdir"
cp -a "$srcdir" "$appdir"
cp "$packdir/docker-wrapper"-* "$appdir"
chown -R "$username:$groupname" "$appdir"
