#! /bin/sh
git clone --bare https://www.github.com/alterionx/dotfiles.git $HOME/cfg.git
alias config='/usr/bin/git --git-dir=$HOME/.cfg.git/ --work-tree=$HOME'
config fetch --all
config reset --hard origin/master

