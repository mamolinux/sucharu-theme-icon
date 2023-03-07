#!/bin/bash
# -*- coding: UTF-8 -*-
## Search duplicate SVG icons with [find](https://salsa.debian.org/debian/findutils)
## usage:
##
## options:
##     -a, --all                Search for duplicates of ALL the icons in icons/src/<variant> [default:0]
##     -v, --variant <name>     Search for duplicates of the icons in icons/src/<variant> [default:default]
##     -c, --context <name>     Search for duplicates of ALL the icons in icons/src/<variant>/<context>
##     -f, --file <name>        Search for duplicates of the icon only in icons/src/<variant>/<context>/<path> (needs --context)
##
## NOTE:
## contexts are: actions, apps, camera, categories, devices, emblems, emotes, generic-symbols, legacy, mimetypes, multimedia, phosh, places, status, time, ui.


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

info() {
  echo [+] $@
}

fatal() {
  echo [!] $@
  exit 1
}

contexts=( actions apps camera categories devices emblems emotes generic-symbols legacy mimetypes multimedia phosh places status time ui )

###################################################
# CHECKS
###################################################

# current workding directory expected to be Sucharu/icons/src/scalable
CWD=$(pwd)
if [[ ! ${CWD} =~ "icons/src/scalable" ]]; then
  fatal "unexpected working directory ${CWD}. Please execute the script under Sucharu/icons/src/scalable folder."
fi
info "working directory OK."

###################################################
# FUNCTIONS
###################################################
search_dupes() {
  VARIANT=$1
  GROUP=$2
  SERACHGRP=$3
  NAME=$4

  INPUT=${VARIANT}/${GROUP}/${NAME}
  [[ ! -f ${INPUT} ]] && fatal "could not find input file: ${INPUT}"
  cmd="find ${VARIANT}/${SERACHGRP} -name "${NAME}""
  # echo "$cmd"
  $cmd #> /dev/null
}

###################################################
# MAIN
###################################################

# find single file
if [[ ! -z ${_file} ]]; then
  [[ -z ${_context} ]] && fatal "No icon context found! Please provide the icon context with --context."
  info "searching duplicates of ${_variant}/${_context}/${_file}"
  for context in "${contexts[@]}"; do
    search_dupes $_variant $_context $context $_file
  done
  exit 0
fi

# find single context
if [[ ! -z ${_context} ]]; then
  count=$(ls ${_variant}/${_context}/*.svg | wc -l)
  let i=1
  for file in $(ls ${_variant}/${_context}); do
    echo "[$i/$count] searching duplicates of ${_variant}/${_context}/${file}"
    for context in "${contexts[@]}"; do
      search_dupes $_variant $_context $context $file
    done
    let i++
  done
  exit 0
fi

# find all
if [[ ! -z ${_all} ]]; then
  for context in "${contexts[@]}"; do
    # If the variant is not the default one, check if context exist
    if [[ ${VARIANT} == "default" || (${VARIANT} != "default" && -d "${_variant}/${context}") ]]; then
      info "rendering context ${context} of ${_variant} variant"
      count=$(ls ${_variant}/${context} | wc -l)
      let i=1
      for file in $(ls ${_variant}/${context}); do
        info "[$i/$count] rendering ${_variant}/${context}/${file}"
        for context in "${contexts[@]}"; do
          search_dupes $_variant $_context $context $file
        done
        let i++
      done
    fi
  done
  exit 0
fi

fatal "no command given!"
