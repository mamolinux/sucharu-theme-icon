#!/bin/bash
# -*- coding: UTF-8 -*-
## Search if an existing scalable SVG or fullcolor png icon is being replaced by a symlink
## usage:
##
## options:
##     -a, --all                Search for duplicates of ALL the icons in icons/src/<variant> [default:0]
##     -v, --variant <name>     Search for duplicates of the icons in icons/src/<variant> [default:default]
##     -c, --context <name>     Search for duplicates of ALL the icons in icons/src/<variant>/<context>
##
## NOTE:
## contexts are:
## for scalable SVG: actions, apps, camera, categories, devices, emblems, emotes, generic-symbols, legacy, mimetypes, multimedia, phosh, places, status, time, ui.
## for fullcolor png: actions, apps, categories, devices, emblems, legacy, mimetypes, places, status, wip.

# Default values
_all=0
_variant=default

# No-arguments is not allowed
[ $# -eq 0 ] && sed -ne 's/^## \(.*\)/\1/p' $0 && exit 1

# Converting long-options into short ones
for arg in "$@"; do
  shift
  case "$arg" in
"--all") set -- "$@" "-a";;
"--variant") set -- "$@" "-v";;
"--context") set -- "$@" "-c";;
"--file") set -- "$@" "-f";;
  *) set -- "$@" "$arg"
  esac
done

function print_illegal() {
    echo Unexpected flag in command line \"$@\"
}

# Parsing flags and arguments
while getopts 'hav:c:f:' OPT; do
    case $OPT in
        h) sed -ne 's/^## \(.*\)/\1/p' $0
           exit 1 ;;
        a) _all=1 ;;
        v) _variant=$OPTARG ;;
        c) _context=$OPTARG ;;
        f) _file=$OPTARG ;;
        \?) print_illegal $@ >&2;
            echo "---"
            sed -ne 's/^## \(.*\)/\1/p' $0
            exit 1
            ;;
    esac
done

context=$1
# contexts=( actions apps camera categories devices emblems emotes generic-symbols legacy mimetypes multimedia phosh places status time ui )

src=$_variant/$context
for f in `find $src -name "*.svg" | sort`; do
  svg=`echo $f | cut -d "/" -f 3`
  links=`cat ../symlinks/symbolic/$context.list | cut -d " " -f 2`
  for link in $links; do
    if [[ ${svg} == "$link" ]];then
      echo $svg
    fi
  done
done
