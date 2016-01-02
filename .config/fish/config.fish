. ~/.config/fish/aliases.fish

# Globals
set -gU EDITOR emacs
set -gU UBER_HOME="$HOME/Uber"
set -gU UBER_OWNER="benfleis@uber.com"
set -gU VAGRANT_DEFAULT_PROVIDER=aws

[ -s "/usr/local/bin/virtualenvwrapper.sh" ]; and bash /usr/local/bin/virtualenvwrapper.sh
[ -s "$HOME/.nvm/nvm.sh" ]; and bash $HOME/.nvm/nvm.sh

# Interactive/login shells
if status --is-login
    . ~/.config/fish/env.fish
end
