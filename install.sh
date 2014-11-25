#!/bin/bash
source helper-functions.sh
DROPBOX_SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
USER=$(whoami)
HOME_DIR=/home/$USER
VIM_ROOT=$HOME_DIR/.vim

assertDirectoryPresent $HOME_DIR
assertDirectoryPresent $DROPBOX_SCRIPTS_DIR/bashrc.d
assertDirectoryPresent $DROPBOX_SCRIPTS_DIR/vimrc.d
assertFilePresent $DROPBOX_SCRIPTS_DIR/bashrc
assertFilePresent $DROPBOX_SCRIPTS_DIR/vimrc
assertFilePresent $DROPBOX_SCRIPTS_DIR/ssh_config

updateOrInstall vim-pathogen           https://github.com/tpope/vim-pathogen.git
updateOrInstall vim-nerdtree           https://github.com/scrooloose/nerdtree.git
updateOrInstall vim-nerdcommenter      https://github.com/scrooloose/nerdcommenter.git
updateOrInstall vim-fugitive           https://github.com/tpope/vim-fugitive.git
updateOrInstall vim-visual-star-search https://github.com/bronson/vim-visual-star-search.git
#updateOrInstall vim-taglist       https://github.com/vim-scripts/taglist.vim.git
#updateOrInstall vim-taglist       http://sourceforge.net/projects/vim-taglist/files/latest/download?source=files 

verifySymlink $DROPBOX_SCRIPTS_DIR/bashrc         $HOME_DIR/.bashrc
verifySymlink $DROPBOX_SCRIPTS_DIR/bashrc.d       $HOME_DIR/.bashrc.d
verifySymlink $DROPBOX_SCRIPTS_DIR/ssh_config     $HOME_DIR/.ssh/config
verifySymlink $DROPBOX_SCRIPTS_DIR/vimrc          $HOME_DIR/.vimrc
verifySymlink $DROPBOX_SCRIPTS_DIR/vimrc.d/colors $VIM_ROOT/colors
verifySymlink $DROPBOX_SCRIPTS_DIR/vimrc.d/indent $VIM_ROOT/indent
verifySymlink $VIM_ROOT/bundle/vim-pathogen/autoload/pathogen.vim $VIM_ROOT/autoload/pathogen.vim
