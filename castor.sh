#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

update_readme() {
  readme_file=${1}
  project_name=${2}

  declare -A replacement_dictionary
  replacement_dictionary["<PROJECT NAME>"]="${project_name}"
  # Array of lines for the new readme file
  new_readme_array=()
  # Backup the xml file
  cd ${project_name}
  cp "README.md" "README.md.bak"
  # Read the readme into an array of lines
  readarray readme_file_lines_array < ${readme_file}
  # Make necessary replacements
  for key in "${readme_file_lines_array[@]}";
  do
    for replacement_key in "${!replacement_dictionary[@]}"
    do
      replacement_value=${replacement_dictionary[$replacement_key]}
      key=${key/$replacement_key/$replacement_value}
    done
    new_readme_array+=("$key")
  done
  printf '%s' "${new_readme_array[@]}" > "${readme_file}.new"
  # Everything is good; replace
  mv "${readme_file}.new" "${readme_file}"
# Cleanup
  rm "${readme_file}.bak"
}

get_username_and_password ()
{
  credentials_file=$DIR/.credentials
  # If credentials are there, do nothing
  if [ -f $credentials_file ]; then
    github_username=`sed -n 1p ${credentials_file}`
    # github_password=`sed -n 2p ${credentials_file}`
    return
  fi
  # Othersie, prmopt user; write to file
  echo -n "Github username: "
  read github_username
  # echo -n "Github password: "
  # read -s github_password

  echo "Save username locally?"
  read -p "$1 [y/N]: " yn
  if [ "$yn" = "" ]; then
    yn='N'
  fi
  case $yn in
      [Yy] )
        echo $github_username > $credentials_file
        # echo $github_password >> $credentials_file
        echo "Saved"
        return
      ;;
      [Nn] )
        return
      ;;
      *)
        return
      ;;
  esac
}

cast_new_project() {
  # Array to capture user input
  declare -A projects=(['1']=python
                       ['2']=bash
                       ['3']=plain_text)

  project_name=$1
  echo "starting new project, ${project_name}"

  echo "What type of project is this?"
  echo "  [1] Python/Django
  [2] Bash
  [3] Plain Text (Default)"
  read choice
  type=${projects[$choice]}

  # Create new dir with the given name
  echo "Casting from mold..."
  cd ..

  # Init git and copy appropriate mold
  # git init
  cp -r $DIR/molds/$type ./${project_name}
  cp -r $DIR/molds/.editorconfig .
  update_readme ./README.md ${project_name}

  exit 1
  # Run specific mold script
  ./initialize_project.sh $project_name
  rm initialize_project.sh

  # Add everything for pushing
  {
    git add .
    git commit -m "Started project, ${project_name}">> /dev/null
  } &> /dev/null

  echo "Casted"
  get_username_and_password
  echo "Pushing cast..."

  # Push to remote
  curl -u $github_username https://api.github.com/user/repos -d "{\"name\": \"$project_name\"}"
  git remote add origin git@github.com:$github_username/$project_name.git
  git push -u origin master
  echo "Cast pushed"

  echo "Opening remote..."
  sleep 1s
  open https://github.com/$github_username/$project_name
}

if [ $# -eq 0 ]
then
  help_string_function
fi

help_string_function() {
  echo "usage:  castor [option]"
  echo "Options and arguments:"
  echo "-h|--help                 : show this help message"
  echo "-c|--cast|--create <NAME> : cast new project"
}

case $1 in
    -h*|--help)
      help_string_function
    ;;
    -c|--cast|--create)
      cast_new_project $2
    ;;
    *)
      echo "Option not recognized ($1);"
      help_string_function
    ;;
esac
