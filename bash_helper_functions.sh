#!/usr/bin/env bash

# CWD is the directory where this file is on disk
CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Carriage return for string construction
cr=`echo $'\n.'`
cr=${cr%.}

#######################################
# Get a string from a file on disk
# If file not present, prompt user for
# string, and write it to new file
# Globals:
# Arguments:
#   filename
#   user prompt
# Returns:
#   setting string 
#######################################
get_saved_setting() {
  # get saved setting fn
  setting_file_name="${1}"
  user_prompt="${2}"

  setting_file="${CWD}"/"${setting_file_name}"
  # If setting file is present, read the first line
  if [ -f "${setting_file}" ]; then
    saved_setting=$(sed -n 1p "${setting_file}")
  else
    # Otherwise, prmopt user; write to file
    read -rp "${user_prompt}" saved_setting

    echo "${saved_setting}" >> "${setting_file}"
  fi
  # Done, return the setting string to the caller function 
  echo "${saved_setting}"
}


#######################################
# Present a list of string choices to 
# the user
# Based on user's input, echo the
# chosen string
# Globals:
# Arguments:
#   query for the prompt to the user 
#   associative array for the choices
#   default choice key is user
#   makes no choice
# Returns:
#   chosen string 
#######################################
get_choice_from_user() {
  query_for_prompt="${1}"
  array_input=$(declare -p "$2")
  eval "declare -A choice_dictionary="${array_input#*=}
  default_choice="${3}"

  prompt_for_user_input="${query_for_prompt}${cr}"

  for choice_key in "${!choice_dictionary[@]}"; do
    choice_value=${choice_dictionary[$choice_key]}
    prompt_for_user_input="${prompt_for_user_input} [$choice_key] $choice_value ${cr}"
  done

  read -rp "$prompt_for_user_input" choice
  if [[ -z "${choice}" ]]; then
    choice="${default_choice}"
  fi
  type=${choice_dictionary[$choice]}
  echo "${type}"
}

#######################################
# Mkdir, and if the folder already 
# exists, do nothing. ¯\_(ツ)_/¯
#######################################
mkdir_ignore_if_present() {
  mkdir "${1}" >>/dev/null
}

#######################################
# Update a text file, by making 
# word replacements
# Globals:
# Arguments:
#   filename to read
#   associative array of replacements
# Returns:
#######################################
update_text_file() {
  text_file_name=${1}
  array_input=$(declare -p "$2")
  eval "declare -A replacement_dictionary="${array_input#*=}

  # Array of lines for the new text file
  new_text_array=()

  # Backup the file
  cp "${text_file_name}" "${text_file_name}.bak"

  # Read the text into an array of lines
  readarray text_file_lines_array < "${text_file_name}"
  # Make necessary replacements in the array
  for key in "${text_file_lines_array[@]}"; do
    for replacement_key in "${!replacement_dictionary[@]}"; do
      replacement_value=${replacement_dictionary[$replacement_key]}
      key=${key/$replacement_key/$replacement_value}
    done
    new_text_array+=("$key")
  done

  # Done, new_text_array has all the new text
  # Write this array to new text file
  printf '%s' "${new_text_array[@]}" >"${text_file_name}.new"

  # TODO; arror check?
  # Everything is good; replace original file with new one
  mv "${text_file_name}.new" "${text_file_name}"
  # Cleanup backup
  rm "${text_file_name}.bak"
}
