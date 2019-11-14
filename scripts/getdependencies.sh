#!/bin/bash

runtime_deps() {
  egrep "^[ 	]*depends_on" "$1" | sed -e 's|^[ 	]*depends_on||' | sed -e 's|"||g' | awk '{print $1}'
}
build_deps() {
  egrep "^[ 	]*depends_on.*=>[ 	]*:build" "$1" | awk '{print $1}'
}

runtime_deps_recursive() {
   local pkgfile="$1"
   local dep
   if [ ! -e "${pkgfile}" ]; then
       echo "missing $pkgfile" 1>&2
       return
   fi
   echo "$pkgfile"
   runtime_deps "${pkgfile}" | while read dep; do
      runtime_deps_recursive "$(dirname ${pkgfile})/${dep}.rb"
   done
}

for p in "$@"; do
    p=$(dirname $p)/$(basename $p)
    runtime_deps_recursive "$p"
done | sort -u | while read pkg; do
    grep -c ":sierra" $pkg
done
                       

