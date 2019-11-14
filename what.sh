#!/bin/sh

bintrayroot=https://dl.bintray.com/iem/bottles-sierra
user=$(git config user.name)
email=$(git config user.email)
bintrayorg=iem

user_repo="iem-projects/sierra"
formula=$1

if [ "x${formula}" = "x" ]; then
  echo "usage: $0 <formula>" 1>&2
  exit 1
fi

echo "# creating the bottle"
echo brew test-bot --root-url=${bintrayroot} --bintray-org=${bintrayorg} --tap=${user_repo} ${user_repo}/${formula}
echo "# uploading the bottle"
echo brew test-bot --ci-upload --git-name=\"${user}\" --git-email=\"${email}\" --bintray-org=${bintrayorg} --root-url=${bintrayroot}
