#!/usr/bin/env bash

# "import" the helper functions
CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "${CWD}"/bash_helper_functions.sh

cast_new_project() {
  project_name="${1}"

  # Choices for type of projects
  declare -A project_type_choice_list
  project_type_choice_list["1"]="plain_text"
  project_type_choice_list["2"]="bash"
  project_type_choice_list["3"]="python (django)"
  # Prompt user for the type of project they want to make
  type_from_user=$(get_choice_from_user "What type of project is this?" "project_type_choice_list" "1")
  upper_choice=$(echo "${type_from_user}" | awk '{print toupper($0)}')

  # We have name of project and type of project, print them
  echo "starting new ${upper_choice} project, '${project_name}'"
  # TODO double check with user
  
  # Create new dir with the given name
  echo -n "Casting from mold..."
  initialize_project_from_mold "${type_from_user}" "${project_name}"
  echo "DONE"

  echo "Pushing remote..."
  stage_and_push_to_github "${project_name}"
  echo "DONE"

}

initialize_project_from_mold() {
  type="${1}"
  name="${2}"

  # Init git and copy appropriate mold
  # Copy the mold from the castor molds
  cp -r "${CWD}"/molds/"${type}" ./"${name}"
  cp -r "${CWD}"/molds/.editorconfig .
  # Enter the new folder and initialize git
  cd "${name}" || echo "failed to cd" exit 1
  {
    git init
  } &> /dev/null
  # Update the text of the readme file; this will be the first commit
  # This is an array of replacements for the new readme
  declare -A replacement_dictionary
  replacement_dictionary["<PROJECT NAME>"]="${project_name}"

  update_text_file "README.md" "replacement_dictionary"
  # Run specific mold script
  if [ -f initialize_project.sh ]; then
    ./initialize_project.sh "${name}"
    rm initialize_project.sh
  fi

}

# TODO; get rid of all the output from git stuff
stage_and_push_to_github() {
  name="${1}"

  # Get the credentials needed to push
  github_username=$(get_saved_setting "github_username.txt" "GitHub username?] ")
  otp_code=$(get_saved_setting "github_otp_code.txt" "OTP (2FA) Code for GitHub?] ")
  echo "${otp_code}"
  # Construct the curl command used to push
  # Ugly backslashed are for quote escaping in json
  username_section="curl -u ${github_username}" 
  header_section="" 
  if [[ ! -z "${otp_code}" ]]; then
    header_section="-H \"Authorization: token ${otp_code}\""
  fi
  data_section="-X POST -d \"{\\\"name\\\": \\\"$name\\\"}\""
  url_section="https://api.github.com/user/repos"
  # Execute the github curl command
  github_curl_command="${username_section} ${header_section} ${data_section} ${url_section}"
  echo "${github_curl_command}"
  eval "${github_curl_command}"

  # Now that the remote GitHub repo hasbeen created, associate with the local git root
  git remote add origin git@github.com:"${github_username}"/"${name}".git
  # Stage a commit with the local file
  {
    git add .
    git commit -m "Started project, ${name}" >>/dev/null
  } &>/dev/null
  # Finally, push the local commit
  git push -u origin master
}

open_on_github() {
  sleep 1s
  open https://github.com/"${github_username}"/"${name}"
}
