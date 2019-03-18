#!/bin/bash -e

cd $(dirname $0)

mkdir -p b
cd b
if [[ ! -d "buildaux" ]]; then
    echo -e "-- Cloning [buildaux]: git clone https://github.com/tamaskenez/buildaux.git b/buildaux"
    git clone https://github.com/tamaskenez/buildaux.git
else
    cd buildaux
    git pull --ff-only
    cd -
fi
