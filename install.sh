#!/bin/bash
DROPBOX_SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
USER=$(whoami)
HOME_DIR=/home/$USER
VIM_ROOT=$HOME_DIR/.vim

if [ ! -d $HOME_DIR ];                       then echo "Unable to find home directory for current user ($HOME_DIR)"; exit 1; fi
if [ ! -f $DROPBOX_SCRIPTS_DIR/bashrc ];     then echo "Unable to find bashrc script in $DROPBOX_SCRIPTS_DIR!"; exit 1; fi
if [ ! -d $DROPBOX_SCRIPTS_DIR/bashrc.d ];   then echo "Unable to find bashrc.d script in $DROPBOX_SCRIPTS_DIR!"; exit 1; fi
if [ ! -f $DROPBOX_SCRIPTS_DIR/vimrc ];      then echo "Unable to find vimrc script in $DROPBOX_SCRIPTS_DIR!"; exit 1; fi
if [ ! -f $DROPBOX_SCRIPTS_DIR/ssh_config ]; then echo "Unable to find ssh_config script in $DROPBOX_SCRIPTS_DIR!"; exit 1; fi

verifySymlink() {
   if [ $# != 2 ]; then echo "verifySymlink: expected 2 arguments, received $#!"; exit 1; fi
   linkedFile=$1
   linkName=$2
   if [ ! -e $linkedFile ]; then echo "WARNING: verifySymlink: specified target doesn't exist ($linkedFile)!" >&2; fi
   if [ ! -h  $linkName -o ! "$(readlink $linkName)" = "$linkedFile" ]; then
      rm -f $linkName
      ln -s $linkedFile $linkName
   fi
}

updateOrInstall() {
   if [ $# != 2 ]; then echo "updateOrInstall: expected 2 arguments, received $#!"; exit 1; fi
   pluginName=$1
   githubUrl=$2

   if [ ! -d $VIM_ROOT/bundle/$pluginName ]; then
      pushd $VIM_ROOT/bundle > /dev/null
      git clone $githubUrl $pluginName
      popd > /dev/null
   else
      pushd $VIM_ROOT/bundle/$pluginName
      git pull
      popd >/dev/null
   fi
}

if [ ! -d $VIM_ROOT/autoload ]; then mkdir $VIM_ROOT/autoload; fi
if [ ! -d $VIM_ROOT/bundle ];   then mkdir $VIM_ROOT/bundle;   fi

updateOrInstall vim-pathogen https://github.com/tpope/vim-pathogen.git
updateOrInstall vim-nerdtree https://github.com/scrooloose/nerdtree.git
updateOrInstall vim-fugitive https://github.com/tpope/vim-fugitive.git
updateOrInstall vim-taglist  https://github.com/vim-scripts/taglist.vim.git

verifySymlink $DROPBOX_SCRIPTS_DIR/bashrc         $HOME_DIR/.bashrc
verifySymlink $DROPBOX_SCRIPTS_DIR/bashrc.d       $HOME_DIR/.bashrc.d
verifySymlink $DROPBOX_SCRIPTS_DIR/ssh_config     $HOME_DIR/.ssh/config
verifySymlink $DROPBOX_SCRIPTS_DIR/vimrc          $HOME_DIR/.vimrc
verifySymlink $DROPBOX_SCRIPTS_DIR/vimrc.d/colors $VIM_ROOT/colors
verifySymlink $DROPBOX_SCRIPTS_DIR/vimrc.d/indent $VIM_ROOT/indent
verifySymlink $VIM_ROOT/bundle/vim-pathogen/autoload/pathogen.vim $VIM_ROOT/autoload/pathogen.vim
