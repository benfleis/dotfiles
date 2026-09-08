export GEN=ninja
export DUCKDB_PLATFORM=linux_x64
export DUCKDB_LINKER=mold

# match iso-claude
export VCPKG_TOOLCHAIN_PATH=/opt/workspace/src/vcpkg/scripts/buildsystems/vcpkg.cmake
export SCCACHE_DIR=/opt/workspace/.cache/sccache

# dbuild shuold already be loaded, first check that then replace
dbuild() {
  [[ "$PWD" == /opt/workspace/* ]] || {
    echo "PWD must be under /opt/workspace/ -- aborting." >&2
    return 1
  }
  echo "Running in iso-shell: $@"
  iso-shell -c "cd $PWD; dbuild"
}
