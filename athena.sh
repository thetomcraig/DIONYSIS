#!/usr/bin/env bash

load_project_array() {
  memory="./user_data/project_list.txt"
  declare -A projects

  while IFS='' read -r line || [[ -n "$line" ]]; do
    IFS=',' read -r -a name_and_var <<< "$line"
    key=${name_and_var[0]}
    value=${name_and_var[1]}
    projects[$key]=$value
  done < "$memory"
  # projects array now holds all projects:
    # key = tmux session name
    # value = human readable name
  for i in "${!projects[@]}"
  do
    echo "  ${projects[$i]}"
  done
}
help_string_function() {
  echo "usage:  ATHENA [option]"
  echo "Options and arguments:"
  echo "help             : show this help message"
  echo "list             : list all projects"
  echo "commands         : show commands for current project"
  echo "start            : show interactive launcher menu"
  echo "rename [a] [b]   : rename project [a] to project [b]"
  echo "config           : show configuration file for current project"
  echo "delete [project] : delete a project"
  echo "add [project]    : add a project"
}

if [ $# -eq 0 ]
then
  echo "ATHENA projects:"
  load_project_array
fi

case $1 in
    help)
      help_string_function
      exit 0
    ;;
    list)
      echo "ATHENA projects:"
      load_project_array
      exit 0
    ;;
    commands)
      echo "ATHENA commands for $current_session:"
    ;;
    *)
      echo "Option not recognized ($1);"
      help_string_function
      exit 0
    ;;
esac

