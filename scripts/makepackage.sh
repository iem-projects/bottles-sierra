#!/bin/sh

user=$1
apikey=$2
repository=$3
name=$4
apiurl=https://bintray.com/api/v1

usage() {
  echo "usage: $0 <bintrayuser> <bintraykey> <repo> <name>"
  exit 1
}

if [ "x${name}" = "x" ]; then
 usage
fi

name_=$(echo $name | sed -e 's|@|:|g')



makepackage() {
cat <<EOL
{
  "name": "${name_}",
  "desc": "homebrew-bottle for '${name}' targetting macOS/sierra",
  "licenses": ["BSD 3-Clause"],
  "vcs_url": "https://github.com/iem-projects/sierra.git",
  "github_repo": "iem-projects/sierra",
  "public_download_numbers": true
}
EOL
}

curl \
	-u ${user}:${apikey} \
	--request POST \
	--header "Content-Type: application/json" \
	--data "$(makepackage)" \
	${apiurl}/packages/${user}/${repository}
