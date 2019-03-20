#!/bin/bash -e

cd $(dirname $0)

mkdir -p d
readonly DIR=d/buildaux

if [[ ! -d "$DIR" ]]; then
    echo -e "-- Cloning [buildaux]: cd d && git clone https://github.com/tamaskenez/buildaux.git buildaux"
    cd b && git clone https://github.com/tamaskenez/buildaux.git
else
    echo -e "\n-- Updating [buildaux]: cd $DIR && git pull --ff-only"
    cd "$DIR"
    git pull --ff-only
    cd -
fi

cp "$DIR/1_bootstrap.sh" \
   "$DIR/clang-format-all.sh" \
   "$DIR/.clang-format" \
   .
