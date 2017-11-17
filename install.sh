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
# Verify presence of expected tools
################################################################################
hash dialog  2>/dev/null || { sudo aptitude install dialog;  }

################################################################################
# Verify presence of expected directories and files
################################################################################
actions=()
assertDirectoryPresent $HOME_DIR
assertDirectoryPresent $DROPBOX_SCRIPTS_DIR/bashrc.d
assertFilePresent $DROPBOX_SCRIPTS_DIR/bashrc
assertFilePresent $DROPBOX_SCRIPTS_DIR/ssh/config.external
assertFilePresent $DROPBOX_SCRIPTS_DIR/ssh/config.internal
assertFilePresent $DROPBOX_SCRIPTS_DIR/ssh/config.sshuttle

verifySymlink $DROPBOX_SCRIPTS_DIR/bashrc              $HOME_DIR/.bashrc
verifySymlink $DROPBOX_SCRIPTS_DIR/bashrc.d            $HOME_DIR/.bashrc.d
verifySymlink $DROPBOX_SCRIPTS_DIR/tmux.conf           $HOME_DIR/.tmux.conf
actions+=("Verified symbolic link to bashrc file")
actions+=("Verified symbolic link to tmux config")

cmd=(dialog --separate-output --checklist "Select ssh config file:" 22 76 16)
options=(
   1 "internal" on    # any option can be set to default to "on"
   2 "external" off
   3 "sshuttle" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
   case $choice in
      1) connection="internal";;
      2) connection="external";;
      3) connection="sshuttle";;
      *) connection="internal"; echo "Unknown option!!";;
   esac
done
verifySymlink $DROPBOX_SCRIPTS_DIR/ssh/config.$connection $HOME_DIR/.ssh/config
actions+=("Selected ssh config $connection")

################################################################################
# Show info on actions
################################################################################
if [ ${#actions[@]} -gt 0 ]; then
   message="";

   # Add underlined title
   title="Executed ${#actions[@]} actions:";
   message="$message$title\n";
   for ((c=1; c<=${#title}; c++)); do message="$message="; done
   message="$message\n";

   # Add messages about executed actions
   for executedAction in "${actions[@]}"; do
      message="$message  - $executedAction\n";
   done
   dialog --title "Info on actions" --msgbox "$message" 1000 1000
   clear;
else
   dialog --title "Info on actions" --msgbox "No actions executed" 12 55
   clear;
fi
