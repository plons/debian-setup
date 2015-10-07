#!/bin/bash

################################################################################
# Parse parameters
################################################################################
function show_help {
    echo "Install bash config and ssh config and create required symbolic links.";
    echo "  -h Show this help function";
}
OPTIND=1         # Reset in case getopts has been used previously in the shell.
verbose=0
update=0
while getopts "h?vu" opt; do
   case "$opt" in
      h|\?)
         show_help
         exit 0
         ;;
      v)  verbose=1 ;;
   esac
done
shift $((OPTIND-1))

################################################################################
# Determine important directories
################################################################################
DROPBOX_SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
USER=$(whoami)
HOME_DIR=/home/$USER

source helper-functions.sh

################################################################################
# Verify presence of expected directories and files
################################################################################
assertDirectoryPresent $HOME_DIR
assertDirectoryPresent $DROPBOX_SCRIPTS_DIR/bashrc.d
assertFilePresent $DROPBOX_SCRIPTS_DIR/bashrc
assertFilePresent $DROPBOX_SCRIPTS_DIR/ssh/external.config

verifySymlink $DROPBOX_SCRIPTS_DIR/bashrc              $HOME_DIR/.bashrc
verifySymlink $DROPBOX_SCRIPTS_DIR/bashrc.d            $HOME_DIR/.bashrc.d
verifySymlink $DROPBOX_SCRIPTS_DIR/ssh/external.config $HOME_DIR/.ssh/config
