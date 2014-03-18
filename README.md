# Emacs config
My emacs config. And I don't think it's useful for anyone but me.

## Version
Current Emacs version: 24.3

## Installation
Installation script requires **python** (for [Cask](http://cask.github.io/)), **git** and of course **Emacs**.
To install emacs config download [install.sh](https://raw.github.com/vemperor/emacs_config/master/install.sh)

    $ wget https://raw.github.com/vemperor/emacs_config/master/install.sh

Configure paths

    $ emacs install.sh

Run script

    $ chmod u+x install.sh && ./install.sh

## Packages
In order to autoinstall all packages you need to install [Cask](http://cask.github.io/).
After [Cask](http://cask.github.io/) installation go to **.emacs.d** directory & execute

    $ cask

### Update cask file

To update Cask file do

    M-x pallet-init

## Colors
All colors are configured for [Misterioso](https://github.com/tovbinm/emacs-24-mac/blob/master/etc/themes/misterioso-theme.el) theme and "white on black" terminals.

**UPD**
Changed theme to *deeper-blue*. Everything looks fine.

## Xdg (Gnome/KDE/etc) menu
To add Emacs Client to Xdg menu copy .local from repo to your `HOME` directory

    $ cp -r path_to_repo/emacs_client/.local/ ~/

and add executable permissions for all users for .desktop file:

    $ chmod a+x .local/share/applications/emacsclient.desktop

## TODO
Describe useful bindings && workflow.

## Sources
I took a lot of .emacs code from [emacs-fu](http://emacs-fu.blogspot.ru/).
Another one source is, of course, [Emacs Wiki](http://www.emacswiki.org/).
