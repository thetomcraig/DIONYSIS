project_name=$1

django-admin --version &> /dev/null
if [ $? != 0 ]; then
  exit 1
fi
echo "Creating Virtualenv..."
virtualenv env >> /dev/null
source env/bin/activate >> /dev/null
echo "Pip Installing..."
pip install -r requirements.txt >> /dev/null
echo "Creating Django Project"
django-admin startproject $project_name >> /dev/null
echo "DONE"

