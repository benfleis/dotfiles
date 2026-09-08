alias rgt='rg --glob="!duckdb/" --glob="!extension-ci-tools/" --glob="!build/" --glob="!data/" --glob="!target/"'

# pure-zsh relpath: path from $2 (base dir) to $1 (target dir), no realpath/perl dependency
_gsub_relpath () {
  local target="${1:A}" base="${2:A}"
  [[ "$target" == "$base" ]] && { print -r -- "."; return }
  local -a t b rel
  t=("${(s:/:)target}"); t=("${(@)t:#}")
  b=("${(s:/:)base}");   b=("${(@)b:#}")
  local i=1
  while (( i <= ${#t} && i <= ${#b} )) && [[ "${t[i]}" == "${b[i]}" ]]; do (( i++ )); done
    local up=$(( ${#b} - i + 1 ))
      for (( ; up > 0; up-- )); do rel+=(..); done
      for (( ; i <= ${#t}; i++ )); do rel+=("${t[i]}"); done
        (( ${#rel} == 0 )) && { print -r -- "."; return }
          print -r -- "${(j:/:)rel}"
        }

# after a --reference update, git has written an absolute alternates path;
# rewrite it relative to the submodule's own objects dir so it still resolves
# when $HOME's absolute prefix differs (e.g. docker vs host)
_gsub_relativize_alternates () {
  local sm_path="$1" ref="$2"
  local sm_git ref_git alt_file rel
  sm_git=$(git -C "$sm_path" rev-parse --absolute-git-dir 2>/dev/null) || return 0
  ref_git=$(git -C "$ref" rev-parse --absolute-git-dir 2>/dev/null) || return 0
  alt_file="$sm_git/objects/info/alternates"
  [[ -f "$alt_file" ]] || return 0
  rel=$(_gsub_relpath "$ref_git/objects" "$sm_git/objects")
  print -r -- "$rel" > "$alt_file"
  echo "gsub-up: $sm_path -> alternates now relative ($rel)"
}

gsub-up-relative () {
  emulate -L zsh
  local refs_root="${GSUB_REFS_ROOT:-$HOME/src/d}"
  git submodule init || return $?
  local -a lines
  lines=("${(@f)$(git config -f .gitmodules --get-regexp '\.path$')}")
  local line key sm_path name url ref
  for line in $lines
  do
    key=${line%% *}
    sm_path=${line#* }
    name=${key#submodule.}
    name=${name%.path}
    url=$(git config -f .gitmodules --get "submodule.${name}.url")
    ref="${refs_root}/${url:t:r}"
    if [[ -d "$ref/.git" && "${ref:A}" == "${sm_path:A}" ]]
    then
      echo "gsub-up: $sm_path -> reference would be itself ($ref), skipping --reference"
      git submodule update --init --recursive -- "$sm_path"
    elif [[ -d "$ref/.git" ]]
    then
      echo "gsub-up: $sm_path -> referencing $ref"
      git submodule update --init --recursive --reference "$ref" -- "$sm_path" || return $?
      _gsub_relativize_alternates "$sm_path" "$ref"
    else
      echo "gsub-up: $sm_path -> no reference found, plain update"
      git submodule update --init --recursive -- "$sm_path"
    fi
  done
}

# alias gsub-up='git submodule update --init --recursive'
# git submodule update --init, using a local reference clone (under
# GSUB_REFS_ROOT, default ~/src/d/<name>) for each submodule when one
# exists, to dedupe object storage across checkouts (e.g. many extension
# repos all vendoring duckdb). Falls back to a plain update per submodule
# when no matching reference is found.
function gsub-up {
	emulate -L zsh
	local refs_root="${GSUB_REFS_ROOT:-$HOME/src/d}"

	git submodule init || return $?

	local -a lines
	lines=("${(@f)$(git config -f .gitmodules --get-regexp '\.path$')}")

	# NOTE: don't call the submodule-path variable `path` -- zsh ties `path`
	# (array) to `$PATH` (typeset -T), so assigning it clobbers PATH and
	# breaks every command lookup for the rest of the function.
	local line key sm_path name url ref
	for line in $lines; do
		key=${line%% *}
		sm_path=${line#* }
		name=${key#submodule.}
		name=${name%.path}
		url=$(git config -f .gitmodules --get "submodule.${name}.url")
		ref="${refs_root}/${url:t:r}"

		if [[ -d "$ref/.git" ]]; then
			echo "gsub-up: $sm_path -> referencing $ref"
			git submodule update --init --recursive --reference "$ref" -- "$sm_path"
		else
			echo "gsub-up: $sm_path -> no reference found, plain update"
			git submodule update --init --recursive -- "$sm_path"
		fi
	done
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

