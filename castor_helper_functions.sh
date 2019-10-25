#!/usr/bin/env bash

# "import" the helper functions
CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "${CWD}"/bash_helper_functions.sh

#######################################
# Create new project
#   Create list of options for user
#   Initialize project with that choice
# Globals:
# Arguments:
#   project name
# Returns:
#######################################
cast_new_project() {
  project_name="${1}"

  # Choices for type of projects
  declare -A project_type_choice_list
  project_type_choice_list["1"]="plain_text"
  project_type_choice_list["2"]="bash"
  project_type_choice_list["3"]="python"
  # Prompt user for the type of project they want to make
  type_from_user=$(get_choice_from_user "What type of project is this?" "project_type_choice_list" "1")
  upper_choice=$(echo "${type_from_user}" | awk '{print toupper($0)}')

  # We have name of project and type of project, print them
  echo "starting new ${upper_choice} project, '${project_name}'"
  # TODO double check with user
  
  # Create new dir with the given name
  echo "Casting from mold..."
  initialize_project_from_mold "${type_from_user}" "${project_name}"
  echo "DONE"

  echo "Staging commit..."
  stage_first_commit "${project_name}"
  echo "DONE"

  echo "Creating remote repository..."
  echo -n "    "
  create_remote_git_repo "${project_name}"
  echo "DONE"

  echo "Pushing local repository to remote..."
  push_to_github
  echo "DONE"
}

#######################################
# Heavy lifting for making the new 
# project's folder structure
# Globals:
# Arguments:
#   project type
#   project name
# Returns:
#######################################
initialize_project_from_mold() {
  type="${1}"
  name="${2}"

  # Init git and copy appropriate mold
  # "mold" is the basic starter files for the project
  cp -r "${CWD}"/molds/"${type}" ./"${name}"
  cp -r "${CWD}"/molds/.editorconfig .
  # Enter the new folder and initialize git
  cd "${name}" || echo "failed to cd" exit 1
  {
    git init
  } &> /dev/null

  # Update the text of the readme file; this will be the first commit
  # This associative array holds key/value pairs for making word replacements in the README.md file
  declare -A replacement_dictionary
  replacement_dictionary["<PROJECT NAME>"]="${project_name}"
  update_text_file "README.md" "replacement_dictionary"

  # All the files are in place, run the remaining initializing logic
  #   (install libraries, make additional files, etc)
  if [ -f initialize_project.sh ]; then
    ./initialize_project.sh "${name}"
    rm initialize_project.sh
  fi
}

# TODO; get rid of all the output from git stuff
#######################################
# This should be run after all the 
# files are in place locally for the 
# new project
# This will stage a new (init) commit
#######################################
stage_first_commit() {
  # Stage a commit with the local file
  {
    git add .
    git commit -m "Started project, ${name}" >>/dev/null
  } &>/dev/null
}

#######################################
# Create a repo on GitHub using curl
#######################################
create_remote_git_repo() {
  name="${1}"

  # Get the credentials needed to push
  github_username=$(get_saved_setting "github_username.txt" "GitHub username?] ")
  otp_code=$(get_saved_setting "github_otp_code.txt" "OTP (2FA) Code for GitHub? (Optional)] ")
  # Construct the curl command used to push
  # Ugly backslashes are for quote escaping in json
  username_section="curl -s -u ${github_username}" 
  header_section="" 
  if [[ ! -z "${otp_code}" ]]; then
    header_section="-H \"Authorization: token ${otp_code}\""
  fi
  data_section="-X POST -d \"{\\\"name\\\": \\\"$name\\\"}\""
  url_section="https://api.github.com/user/repos"
  # Execute the github curl command
  github_curl_command="${username_section} ${header_section} ${data_section} ${url_section}"
  {
    eval "${github_curl_command}"
  } > /dev/null

  # Now that the remote GitHub repo hasbeen created, associate with the local git project
  # Finally, push
  {
    git remote add origin git@github.com:"${github_username}"/"${name}".git
  } &> /dev/null
}

push_to_github() {
  {
    git push -u origin master
  } &> /dev/null
}

open_on_github() {
  sleep 1s
  open https://github.com/"${github_username}"/"${name}"
}









create_issue() {
  title="${1}"
  body="${1}"

  # Get the credentials needed to push
  github_usertitle=$(get_saved_setting "github_usertitle.txt" "GitHub username?] ")
  otp_code=$(get_saved_setting "github_otp_code.txt" "OTP (2FA) Code for GitHub? (Optional)] ")
  # Construct the curl command used to push
  # Ugly backslashes are for quote escaping in json
  usertitle_section="curl -s -u ${github_usertitle}" 
  header_section="" 
  if [[ ! -z "${otp_code}" ]]; then
    header_section="-H \"Authorization: token ${otp_code}\""
  fi
  data_section="-X POST -d \"{\\\"title\\\": \\\"$title\\\"}\""
  url_section="https://api.github.com/user/repos"
  # Execute the github curl command
  github_curl_command="${usertitle_section} ${header_section} ${data_section} ${url_section}"
  eval "${github_curl_command}"

  # Now that the remote GitHub repo hasbeen created, associate with the local git project
  # Finally, push
  {
    git remote add origin git@github.com:"${github_username}"/"${title}".git
  } &> /dev/null
}
