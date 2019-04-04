# buildaux

Build related helper stuff for C++ projects.

## Start new C++ repo

- Copy `1_bootstrap.sh` into the root of your repo.
- Run `chmod +x 1_bootstrap.sh`: which clones this repo into `d/` and copies
  a files files (see that script) into the project root.

Directory structure in your project:

- `/b`: build directory
- `/d`: dependencies
- `/i`: install directory

So initialize your main project with something like:

    cmake -H. -Bb -DCMAKE_INSTALL_PREFIX=${PWD}/i -DCMAKE_PREFIX_PATH=${PWD}/i -GXcode
    cmake -H. -Bb -DCMAKE_INSTALL_PREFIX=${PWD}/i -DCMAKE_PREFIX_PATH=${PWD}/i -CMAKE_BUILD_TYPE=Release
    cmake -H. -Bb -DCMAKE_INSTALL_PREFIX=${PWD}/i -DCMAKE_PREFIX_PATH=${PWD}/i

## Other stuff here

- `cmx` is a small helper script to launch cmake with less typing.
- `script_lib.sh` can be sourced in your build script. See
  `2_make_deps.sh.sample`
