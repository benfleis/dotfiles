dotfiles
========

**WIP: Completely in disarray**

To experimentally bootstrap this on an arbitrary host:

  curl <https://raw.githubusercontent.com/benfleis/dotfiles/master/bootstrap.bash>
  bash bootstrap.bash

This will create a --bare clone in src/dotfiles.git, and check it out in $HOME.
Git will complain if there are conflicting files. You must clear them out
yourself for this to work. (Maybe I'll add --force later.)
