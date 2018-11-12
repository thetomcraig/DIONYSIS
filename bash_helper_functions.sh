#!/usr/bin/env bash

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

get_choice_from_user() {
  # Array to capture user input
  declare -A projects=(['1']=plain_text
    ['2']=bash
    ['3']=python)

  read -rp " \
What type of project is this?
    [1] Plain Text (Default)
    [2] Bash
    [3] Python/Django
      : " choice
  if [[ -z "${choice}" ]]; then
    choice=1
  fi
  type=${projects[$choice]}
  echo "${type}"
}

mkdir_ignore_if_present() {
  mkdir "${1}" >>/dev/null
}

update_readme() {
  readme_file=${1}
  project_name=${2}

  declare -A replacement_dictionary
  replacement_dictionary["<PROJECT NAME>"]="${project_name}"
  # Array of lines for the new readme file
  new_readme_array=()
  # Backup the xml file
  cp "README.md" "README.md.bak"
  # Read the readme into an array of lines
  readarray readme_file_lines_array <"${readme_file}"
  # Make necessary replacements
  for key in "${readme_file_lines_array[@]}"; do
    for replacement_key in "${!replacement_dictionary[@]}"; do
      replacement_value=${replacement_dictionary[$replacement_key]}
      key=${key/$replacement_key/$replacement_value}
    done
    new_readme_array+=("$key")
  done
  printf '%s' "${new_readme_array[@]}" >"${readme_file}.new"
  # Everything is good; replace
  mv "${readme_file}.new" "${readme_file}"
  # Cleanup
  rm "${readme_file}.bak"
}

