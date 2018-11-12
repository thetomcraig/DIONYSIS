#!/usr/bin/env bash
CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $CWD/castor_helper_functions.sh

# Interpret the user input
# If they did not pass a command, show the help string
if [ $# -eq 0 ]; then
  help_string_function
fi

help_string_function() {
  echo "usage:  castor [option]"
  echo "Options and arguments:"
  echo "-h|--help                 : show this help message"
  echo "-c|--cast|--create <NAME> : cast new project"
}

case $1 in
-h* | --help)
  help_string_function
  ;;
-c | --cast | --create)
  cast_new_project "${2}"
  ;;
*)
  echo "Option not recognized ($1);"
  help_string_function
  ;;
esac
