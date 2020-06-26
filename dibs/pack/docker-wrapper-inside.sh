#!/bin/sh
me="$(readlink -f "$0")"
appdir="$(dirname "$me")"

if [ $# -gt 0 ] ; then

   case "$1" in

      (--tarball)
         tar cC "$appdir" .skfold
         exit 0
         ;;

      (--wrapper)
         cat "$appdir/docker-wrapper-outside.sh"
         exit 0
         ;;

   esac

fi

exec "$appdir/skf" "$@"
