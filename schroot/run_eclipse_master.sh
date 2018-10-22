#!/usr/bin/env sh
export DISPLAY=${1:-':0.0'}

# Previously: use DARWYN_ROOT from /etc/profile
#. /etc/profile
if [ -d /home/peter/git/darwynMaster.master ]; then
   DARWYN_ROOT=/home/peter/git/darwynMaster.master
else
   DARWYN_ROOT=/home/peter/git/darwynMaster
fi
DARWYN_ROOT=$DARWYN_ROOT /home/peter/eclipse/cpp-mars2-master/eclipse
