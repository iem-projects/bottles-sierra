#!/bin/sh

user=$1
apikey=$2
repository=$3
file=$4

if [ ! -e "${file}" ]; then
  echo "usage: $0 <user> <apikey> <repo> <file>" 1>&2
  exit 1
fi

filename=$(basename ${file})
pkgname=$(echo ${filename} | sed -e 's|-[0-9].*||' | sed -e 's|@|:|g')
version=$(echo ${filename} | sed -e 's|\.[^.]*\.bottle.*||' -e 's|.*-||')

curl -u ${user}:${apikey} -T "${file}" https://api.bintray.com/content/${user}/${repository}/${pkgname}/${version}/${filename}?publish=1
