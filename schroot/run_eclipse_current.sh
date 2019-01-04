#!/bin/bash
export DISPLAY=${1:-':0.0'}
eclipse_bin=
if [ -f /home/peter/eclipse/cpp-mars/eclipse ]; then eclipse_bin=/home/peter/eclipse/cpp-mars/eclipse; fi
if [ -f /home/peter/eclipse/cpp-neon/eclipse ]; then eclipse_bin=/home/peter/eclipse/cpp-neon/eclipse; fi
if [ -f /home/peter/eclipse/cpp-oxygen/eclipse ]; then
   eclipse_bin=/home/peter/eclipse/cpp-oxygen/eclipse;
   eclipse_options="-showlocation -data /home/peter/workspaces/eclipse-cpp-oxygen-on-wheezy"
fi

source /home/peter/git/fe.build-environment/fe-project
DARWYN_ROOT=/home/peter/git/darwynMaster.current; \
   ${eclipse_bin} ${eclipse_options}

