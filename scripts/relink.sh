#!/bin/bash

# Args

if [ $# -le 1 ]; then
  echo Usage: `basename $0` 'FROM-PATH' 'TO-PATH' \['SEP'\]
  echo
  echo Update all symbolic links in the current directory
  echo by replacing FROM-PATH with TO-PATH.
  echo
  echo The script assumes that neither FROM-PATH nor TO-PATH
  echo contains the '+' sign.  If this is not the case, change
  echo the separator using the third argument SEP.
  echo
  exit
fi

FROM=$1
TO=$2
SEP='+'

# Update the separator, if provided
if [ $# -eq 3 ]; then
  SEP=$3
fi

SUB=s"$SEP""$FROM""$SEP""$TO""$SEP"

find . -type l \
  -lname "$FROM/*" -printf \
  'ln -nsf "$(readlink "%p"|sed '"$SUB"')" "%p"\n'
