#!/bin/bash

assertFilePresent()
{
   if [ $# != 1 ]; then echo "assertFilePresent: expected 1 arguments, received $#!"; exit 1; fi
   file=$1
   if [ ! -f $file ]; then echo "Unable to find $file!"; exit 1; fi
}

assertDirectoryPresent()
{
   if [ $# != 1 ]; then echo "assertFilePresent: expected 1 arguments, received $#!"; exit 1; fi
   directory=$1
   if [ ! -d $directory ]; then echo "Unable to find $directory!"; exit 1; fi
}


verifySymlink()
{
   if [ $# != 2 ]; then echo "verifySymlink: expected 2 arguments, received $#!"; exit 1; fi
   linkedFile=$1
   linkName=$2
   if [ ! -e $linkedFile ]; then echo "WARNING: verifySymlink: specified target doesn't exist ($linkedFile)!" >&2; fi
   if [ ! -h  $linkName -o ! "$(readlink $linkName)" = "$linkedFile" ]; then
      rm -f $linkName
      ln -s $linkedFile $linkName
   fi
}

updateOrInstall()
{
   if [ $# != 2 ]; then echo "updateOrInstall: expected 2 arguments, received $#!"; exit 1; fi
   if [ -z "$VIM_ROOT" ]; then echo "updateOrInstall: expected VIM_ROOT to be specified!"; exit 1; fi
   pluginName=$1
   pluginUrl=$2
   if [ ! -d $VIM_ROOT/bundle ]; then mkdir $VIM_ROOT/bundle; fi
   if [ ! -d $VIM_ROOT/bundle/$pluginName ]; then
      echo "Installing $pluginName"
      pushd $VIM_ROOT/bundle > /dev/null
      if [[ $pluginUrl =~ .*\.git ]]; then
          git clone $pluginUrl $pluginName
      else
         echo "TODO"
         curl --location --progress-bar --compressed $pluginUrl
      fi
      popd > /dev/null
   else
      echo "Updating $pluginName"
      pushd $VIM_ROOT/bundle/$pluginName > /dev/null
      result="$(git pull)"
      if [ $? != 0 ]; then
         echo "  WARNING: Somthing went wrong while trying to pull: $result";
         echo "  Continueing..." 
      fi
      popd > /dev/null
   fi
}

