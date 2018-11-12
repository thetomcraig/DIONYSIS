#!/usr/bin/env bash

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $CWD/bash_helper_functions.sh

github_username="NONE"

cast_new_project() {
  project_name="${1}"

  type_from_user=$(get_choice_from_user)
  upper_choice=$(echo "${type_from_user}" | awk '{print toupper($0)}')
  echo "starting new ${upper_choice} project, '${project_name}'"
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
  update_readme "$(pwd)/README.md" "${name}"
  # Run specific mold script
  if [ -f initialize_project.sh ]; then
    ./initialize_project.sh "${name}"
    rm initialize_project.sh
  fi

}

stage_and_push_to_github() {
  name="${1}"

  # Stage git commit
  {
    git add .
    git commit -m "Started project, ${name}" >>/dev/null
  } &>/dev/null

  get_username

  # Push to remote
  curl -u "${github_username}" -H "Authorization: token ${otp_code}" -X POST -d "{\"name\": \"$name\"}" https://api.github.com/user/repos
  git remote add origin git@github.com:"${github_username}"/"${name}".git
  git push -u origin master
}

get_username() {
  credentials_file="${CWD}"/.credentials
  # If credentials are there, do nothing
  if [ -f "${credentials_file}" ]; then
    github_username=$(sed -n 1p "${credentials_file}")
    # github_password=`sed -n 2p ${credentials_file}`
    return
  fi
  # Othersie, prmopt user; write to file
  echo -n "Github username: "
  read -r github_username

  echo "Save username locally?"
  read -rp "[y/N]: " yn
  if [ "$yn" = "" ]; then
    yn='N'
  fi
  case $yn in
  [Yy])
    echo "${github_username}" >"${credentials_file}"
    echo "Saved"
    return
    ;;
  [Nn])
    return
    ;;
  *)
    return
    ;;
  esac
}

open_on_github() {
  sleep 1s
  open https://github.com/"${github_username}"/"${name}"
}
