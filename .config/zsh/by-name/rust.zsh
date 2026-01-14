# rust / rustup
# NOTE: do not auto add cargo bin -- rely on manual linkage.
# [[ -x $HOME/.cargo/bin ]] && PATH="$HOME/.cargo/bin:$PATH"
# [[ -r "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# sccache for cargo builds
(($+commands[sccache])) && {
  export RUSTC_WRAPPER=sccache
}
