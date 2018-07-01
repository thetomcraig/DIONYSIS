dionysis_dir=$PWD

sleep 1s
echo "STARTING NEW PROJECT"
echo "New Repo Name:"
read project_name 

cd ..
mkdir $project_name
cd $project_name
git init
cp $dionysis_dir/* .
mv template_readme.md README.md
git add .
git commit -m "Add Readme for $project_name"

echo "Github username"
read username
echo "{\"name\": $project_name}"
curl -u $username https://api.github.com/user/repos -d "{\"name\": \"$project_name\"}"
git remote add origin git@github.com:$username/$project_name.git
git push -u origin master
echo "DONE"
open https://github.com/$username/$project_name

echo "Remove Template Dir? [y\N]"
read answer
if [ "$answer" == "y" ]
then
  rm -rf $dionysis_dir
fi
echo "DONE"
cd ..
echo "NEW PROJECT EXISTS HERE: $project_name"
