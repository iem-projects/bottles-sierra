#!/usr/bin/env python3

import sys
import os
import re
import requests

def runtime_deps(filename):
    try:
        with open(filename) as f:
            data = [_.strip() for _ in f.readlines() if "depends_on" in _ and not ":build" in _]
    except OSError:
        return []
        raise
    deps = []
    for d in data:
        deps += [_.strip('"') for _ in re.findall('".*"', d)]
    return deps

def runtime_deps_r(filename):
    path = os.path.dirname(filename)
    deps = set([filename])
    depnew = []
    if not filename.endswith(".rb"):
        filename+=".rb"

    try:
        depnew = runtime_deps(filename)
    except OSError:
        pass
    deps.update(depnew)
    for d in depnew:
        deps.update(runtime_deps_r(path+d))
    return deps
    

def download(sha256):
    # curl "https://bintray.com/api/v1/search/file?sha1=4b29283a8f69c773d307501a5f89af2a0f5804ce62874b7bd2e6ea89145cf73a"
    r = requests.get("https://bintray.com/api/v1/search/file?sha1=%s" % sha256)
    # https://bintray.com/homebrew/bottles/download_file?file_path=xz-5.2.3.yosemite.bottle.tar.gz
    for data in r.json():
        url =  "https://bintray.com/{owner}/{repo}/download_file?file_path={path}".format(**data)
        # download with "wget --content-disposition ${url}"
        print(url)

def get_sierra(formula):
    sierrafiles = None
    with open(formula) as f:
        sierrafiles = [_.split()[1] for _ in f.readlines() if ":sierra" in _]
    if not sierrafiles:
        print("MISSING: %s" % (formula))
    else:
        print("DEPENDS: %s" % (formula,))
        for s in sierrafiles:
            download(s.strip('"'))

if __name__ == "__main__":
    packages = sys.argv[1:]
    depfiles=set()
    for p in packages:
        path = os.path.dirname(p)
        deps = []
        for d in runtime_deps_r(p):
            if not d.endswith(".rb"):
                d+=".rb"
            if not d.startswith(path):
                d=path+d
            depfiles.update([d])
    depfiles = sorted(depfiles)
    for d in depfiles:
        get_sierra(d)
