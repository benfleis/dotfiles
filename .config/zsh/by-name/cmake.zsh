(($+commands[ninja])) && {
    export GEN=ninja
}
export VCPKG_TOOLCHAIN_PATH=$HOME/src/vcpkg/scripts/buildsystems/vcpkg.cmake
export VCPKG_DISABLE_METRICS=1
export CMAKE_EXPORT_COMPILE_COMMANDS=1
