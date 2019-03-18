# buildaux
Build related helper stuff for C++ projects.

## Start new C++ repo

- Copy `1_bootstrap.sh` and `.gitignore` into the root of your repo.
- `chmod +x 1_bootstrap.sh`

Directory structure in your project:

- `/b`: build directory
- `/d`: dependencies
- `/i`: install directory

So initialize your project with something like:

    cmake -H. -Bb -DCMAKE_INSTALL_PREFIX=${PWD}/i -DCMAKE_PREFIX_PATH=${PWD}/i -GXcode
    cmake -H. -Bb -DCMAKE_INSTALL_PREFIX=${PWD}/i -DCMAKE_PREFIX_PATH=${PWD}/i -CMAKE_BUILD_TYPE=Release
    cmake -H. -Bb -DCMAKE_INSTALL_PREFIX=${PWD}/i -DCMAKE_PREFIX_PATH=${PWD}/i
    
