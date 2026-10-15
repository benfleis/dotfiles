export SCCACHE_BASEDIRS="${SCCACHE_BASEDIRS:-$HOME/src/d}"
export USE_MERGED_VCPKG_MANIFEST=1

# Build the auto-detected DuckDB build dir and run a target (default: unittest).
# Usage: dbuild [target]
# Behavior:
# - 0 build dirs → make debug (your default).
# - exactly 1 → cmake --build that one with the right --config, teeing to local/build-test.log.
# - >1 → prints them and exits non-zero.
dbuild() {
  setopt local_options pipefail
  local repo target build_type config
  repo=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "dbuild: not in a git repo" >&2; return 1 }

  # Known build types -> cmake --config value
  typeset -A configs=(
    debug     Debug
    release   Release
    reldebug  RelWithDebInfo
    relassert RelWithDebInfo
  )

  # Collect the build dirs that actually exist
  local -a found
  for build_type in ${(k)configs}; do
    [[ -d $repo/build/$build_type ]] && found+=$build_type
  done

  if (( ${#found} == 0 )); then
    echo "dbuild: no build dir found; running 'make debug'" >&2
    make -C "$repo" debug
    return
  elif (( ${#found} > 1 )); then
    echo "dbuild: multiple build types: ${found}. Pick one, e.g. cmake --build build/reldebug --config RelWithDebInfo --target $target" >&2
    return 1
  fi

  build_type=${found[1]}
  config=${configs[$build_type]}
  mkdir -p "$repo/local"
  echo "dbuild: building $build_type ($config)" >&2
  cmake --build "$repo/build/$build_type" --config "$config" --target shell --target unittest "$@" 2>&1 \
    | tee "$repo/local/build-test.log"
}


