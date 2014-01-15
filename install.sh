#!/bin/bash

CASK_INSTALLATION_DIR="$HOME/.cask"
EMACS_CONFIG_INSTALLATION_DIR="$HOME"


REQUIRED_EMACS_VERSION="24.3"
SCRIPT_PATH=`/bin/pwd`


function check_python_installation {
    local PYTHON_PATH="$(whereis 'python' | cut -f2 -d ':')"
    if [ "$PYTHON_PATH" == '' ]
    then
        echo 'python not found - you should install python first'
        exit
    else
        echo `python --version`
    fi
}

function check_emacs_installation {
    local EMACS_PATH="$(whereis 'emacs' | cut -f2 -d ':')"
    if [ "$EMACS_PATH" == '' ]
    then
        echo 'Emacs not found - you should install Emacs first'
        exit
    fi
}

function check_emacs_version {
    local EMACS_VERSION="$(emacs --version | head -1 | cut -f3 -d ' ')"
    compare_versions $EMACS_VERSION $REQUIRED_EMACS_VERSION
    if [ "$?" == "9" ]
    then
        echo "Emacs version < $REQUIRED_EMACS_VERSION - you should install Emacs version $REQUIRED_EMACS_VERSION or above"
        exit
    else
        echo `emacs --version | head -1`
    fi
}

# this function was taken from here:
# http://lists.us.dell.com/pipermail/dkms-devel/2004-July/000142.html
function compare_versions {
    [ "$1" == "$2" ] && return 10

	ver1front=`echo $1 | cut -d "." -f -1`
	ver1back=`echo $1 | cut -d "." -f 2-`
	ver2front=`echo $2 | cut -d "." -f -1`
	ver2back=`echo $2 | cut -d "." -f 2-`

	if [ "$ver1front" != "$1" ] || [ "$ver2front" != "$2" ]; then
		[ "$ver1front" -gt "$ver2front" ] && return 11
		[ "$ver1front" -lt "$ver2front" ] && return 9

		[ "$ver1front" == "$1" ] || [ -z "$ver1back" ] && ver1back=0
		[ "$ver2front" == "$2" ] || [ -z "$ver2back" ] && ver2back=0
		compare_versions "$ver1back" "$ver2back"
		return $?
	else
		[ "$1" -gt "$2" ] && return 11 || return 9
	fi
}

function perform_installation {
    install_emacs_config

    install_cask

    run_cask
}

function finish_installation {
    rm -rf $TMP_DIR
}

function install_emacs_config {
    git clone https://github.com/vemperor/emacs_config.git $SCRIPT_PATH/emacs_config
    if [ ! -d "$EMACS_CONFIG_INSTALLATION_DIR" ]
    then
        mkdir $EMACS_CONFIG_INSTALLATION_DIR
    fi

    cp "$SCRIPT_PATH/emacs_config/.emacs" "$EMACS_CONFIG_INSTALLATION_DIR/"
    cp -rf "$SCRIPT_PATH/emacs_config/.emacs.d" "$EMACS_CONFIG_INSTALLATION_DIR/"
    rm -rf "$SCRIPT_PATH/emacs_config"
}

function install_cask {
    if [ ! -d "$CASK_INSTALLATION_DIR" ]
    then
        mkdir $CASK_INSTALLATION_DIR
    fi

    git clone https://github.com/cask/cask.git $CASK_INSTALLATION_DIR

    local CASK_REQUIRE_STRING="(require 'cask \"$CASK_INSTALLATION_DIR/cask.el\")"
    local CASK_SETTINGS_FILE=$EMACS_CONFIG_INSTALLATION_DIR/.emacs.d/local/cask-settings.el

    sed -i "1 c $CASK_REQUIRE_STRING" $CASK_SETTINGS_FILE
}

function run_cask {
    $CASK_INSTALLATION_DIR/bin/cask --path $EMACS_CONFIG_INSTALLATION_DIR/.emacs.d
}


check_emacs_installation
check_emacs_version
check_python_installation
perform_installation


