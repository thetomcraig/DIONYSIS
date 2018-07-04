DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cast_new_project() {
  project_name=$1
  echo "starting new project, ${project_name}"
  mkdir $project_name
  cd $project_name
  git init
  cp $DIR/* .
  mv template_readme.md README.md
  git add .
  git commit -m "Add Readme for $project_name"
}
cd ..

# echo "Github username"
# read username
# echo "{\"name\": $project_name}"
# curl -u $username https://api.github.com/user/repos -d "{\"name\": \"$project_name\"}"
# git remote add origin git@github.com:$username/$project_name.git
# git push -u origin master
# echo "DONE"
# open https://github.com/$username/$project_name

# echo "Remove Template Dir? [y\N]"
# read answer
# if [ "$answer" == "y" ]
# then
  # rm -rf $dionysis_dir
# fi
# echo "DONE"
# cd ..
# echo "NEW PROJECT EXISTS HERE: $project_name"

# if [ $# -eq 0 ]
# then
  # help_string_function
# fi

help_string_function() {
  echo "usage:  castor [option]"
  echo "Options and arguments:"
  echo "-h|--help          : show this help message"
  echo "-c|--cast|--create : show this help message"
}

case $1 in
    -h*|--help)
      help_string_function
      break
    ;;
    -c|--cast|--create)
      cast_new_project $2
      break
    ;;
    *)
      echo "Option not recognized ($1);"
      help_string_function
    ;;
esac
