#!/bin/bash

CMAKE_CXX_STANDARD=17

readonly HAS_XCODE=$(cmake --help | grep Xcode | wc -l | xargs) # 1 if has else 0
readonly HAS_VS=$(cmake --help | grep "Visual Studio" | wc -l | xargs) # 1 if has else 0
readonly BUILD_THREADS=8

if [[ "$HAS_XCODE" == "1" ]]; then
    readonly IDE_GENERATOR=-GXcode
    readonly HAS_IDE_GENERATOR=1
elif [[ "$HAS_VS" == "1" ]]; then
    readonly IDE_GENERATOR= # Will use the default VS generator.
    readonly HAS_IDE_GENERATOR=1
else
    readonly IDE_GENERATOR=
    readonly HAS_IDE_GENERATOR=0
fi

git_dep () {
    url="$1"
    name="$2"
    branch="$3"
    if [[ -z "$url" ]]; then
        echo "git_dep: missing url (\$1)" >&2
        exit 1
    fi
    if [[ -z "$name" ]]; then
        echo "git_dep: missing dependency name (\$2)" >&2
        exit 1
    fi
    if [[ ! -d "d/$name" ]]; then
        echo -e "-- Cloning [$name]: git clone $url d/$name"
        git clone "$url" "d/$name"
        if [[ -n "$branch" ]]; then
            echo -e "-- Switch to branch [$branch]: cd d/$name && git checkout $branch"
            cd "d/$name"
            git checkout "$branch"
            cd -
        fi
    else
        echo "-- cd d/$name"
        cd "d/$name"
        if [[ -n "$branch" ]]; then
            echo -e "-- git checkout $branch"
            git checkout "$branch"
        fi
        echo -e "-- Updating [$name]: git pull --ff-only"
        git fetch --all -p
        git pull --ff-only
        cd -
    fi
}

cmake_dep () {
    if [[ -z "$1" ]]; then
        echo "Missing name (\$1)" >&2
        exit 1
    fi
    name=$1
    shift
    use_ide_generator=0
    config_build_type=
    if [[ $1 == "--try-use-ide" ]]; then
        shift
        if [[ "$HAS_IDE_GENERATOR" == "1" ]]; then
            use_ide_generator=1
            config_build_type=-DCMAKE_BUILD_TYPE=Release
        fi
    fi

    echo -e "\n-- Configuring [$name] with cmake"
    if [[ $use_ide_generator == "1" ]]; then
        (set -x; \
            cmake "-Hd/$name" "-Bb/$name" \
            -DCMAKE_CXX_STANDARD=$CMAKE_CXX_STANDARD \
            -DCMAKE_INSTALL_PREFIX=$PWD/i \
            $IDE_GENERATOR \
            "$@")
    else
        (set -x; \
            cmake "-Hd/$name" "-Bb/$name" \
            -DCMAKE_CXX_STANDARD=$CMAKE_CXX_STANDARD \
            -DCMAKE_INSTALL_PREFIX=$PWD/i \
            $config_build_type \
            "$@")
    fi
    echo -e "\n-- Building [$name] with cmake"
    if [[ $use_ide_generator == "1" ]]; then
        (set -x; \
            cmake \
                --build "b/$name" \
                --config Debug \
                --target install -j $BUILD_THREADS)
        (set -x; \
            cmake \
                --build "b/$name" \
                --config Release \
                --target install -j $BUILD_THREADS)
    else
        (set -x; \
            cmake \
                --build "b/$name" \
                --config Release \
                --target install -j $BUILD_THREADS)
    fi
}
