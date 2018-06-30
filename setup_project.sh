dionysis_dir=$PWD

sleep 1s
echo "STARTING NEW PROJECT"
echo "New Repo Name:"
read project_name 

cd $project_name
git init
cp ../$dionysis_dir/* .
mv template_readme.md README.md
git add .
git commit -m 'Add Readme for $project_name'


echo "Github username"
read username
curl -u $username https://api.github.com/user/repos -d '{"name": $project_name}'
git remote add origin git@github.com:$username/$project_name.git
git push -u origin master

# echo "Remove Template Dir? [y\N]"
# read answer
# if [ "$answer" == "y" ]
# then
  # rm -rf $pwd
# fi
# echo "DONE"
cd ..
echo "NEW PROJECT EXISTS HERE: $project_name"
