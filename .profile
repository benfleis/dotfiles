# exec zsh IFF available
which zsh && exec env SHELL=$(which zsh) zsh -l
