#!/usr/bin/env perl
use strict;
use warnings;

use Cwd;

my @dotfiles = qw/ .zshrc .zshrc.alias .vimrc .tmux.conf /;
my $cwd = getcwd();
my $home = $ENV{'HOME'};

# for my $dotfile (@dotfiles) {
#     system "ln -sf $cwd/$dotfile $home/$dotfile";
# }

my $anyenv = '.anyenv';
if (-f $home/$anyenv) {
    print 'hogehoge';
}
