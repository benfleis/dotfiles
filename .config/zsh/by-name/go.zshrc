# go, presumed to be installed via brew
if command -v gofmt >/dev/null; then
    export GOPATH="$HOME/go"
    export PATH="$GOPATH/bin:$PATH"
fi


