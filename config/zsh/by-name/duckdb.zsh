alias rgt='rg --glob="!duckdb/" --glob="!extension-ci-tools/" --glob="!build/" --glob="!data/" --glob="!target/"'

# git submodule update --init --recursive, borrowing objects from the shared duckdb
# store (git-objects in /opt/tooling) so checkouts don't each carry a copy of duckdb.
# Plain update when the store is missing. Extra args pass through (e.g. a path).
function gsub-up {
	local store="${GIT_OBJECTS_STORE:-/opt/workspace/state/git-objects/duckdb.git}"
	if [[ -d "$store/objects" ]]; then
		git submodule update --init --recursive --reference "$store" "$@"
	else
		echo "gsub-up: no store at $store, plain update" >&2
		git submodule update --init --recursive "$@"
	fi
}

# Idea: leave targets behind, like unittest, duckdb
# wipe out intermediate build object dirs, and rust target dirs
dclean-intermediates() {
  fd --unrestricted --follow \
    --type d \
    --full-path '/build/(?:debug|relassert|reldebug|release)/?/(?:.+[.]dir|rust/src/.*/target)$' \
    . \
    -0 \
    | xargs -0 -n 500 rm -rf
}

# wipe out build dirs
dclean-all() {
  fd --unrestricted --follow \
    --type d \
    --full-path '/build/(?:debug|relassert|reldebug|release)$' \
    . \
    -0 \
    | xargs -0 rm -rf
}

