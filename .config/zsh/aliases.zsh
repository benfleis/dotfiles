# vimlike editors get aliases for vi and view
echo $EDITOR | grep -q vim && {
  alias vi="$EDITOR"
  alias vim="$EDITOR"
  alias view="$EDITOR -R"
  alias vimdiff="$EDITOR -d"
}

# ripgrepd-all + follow links
alias rgi=rg -i
alias rga=rg --follow --hidden --no-ignore
alias rgai=rg --follow --hidden --no-ignore --ignore-case
