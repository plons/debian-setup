#!/bin/bash

packages_to_install=()
while read line; do
   if [[ ! $line =~ \#.* ]] && [[ ! $line =~ ^[[:space:]]*$ ]]; then
      if [[ -z "$(dpkg -l $line 2>/dev/null)" ]]; then
         packages_to_install+=($line)
      fi
   fi
done <packages

if [ ${#packages_to_install[@]} == 0 ]; then
   echo "All packages are already installed!"
else
   echo -n "Do you want to install following packages: ${packages_to_install[@]} [y/N] "
   read answer
   if [ "$answer" == "y" ]; then
      sudo aptitude install ${packages_to_install[@]}
   fi
fi
