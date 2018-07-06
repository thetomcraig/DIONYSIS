project_name=$1

django-admin --version &> /dev/null
if [ $? != 0 ]; then
  exit 1
fi

virtualenv env
source env/bin/activate
pip install -r requirements.txt

django-admin startproject $project_name

