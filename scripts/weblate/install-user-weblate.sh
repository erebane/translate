fail () {
    /opt/hajaannu/bin/bash-logger --msg "$desc"
    exit
}

desc='Create the virtualenv for Weblate'
virtualenv --python=python3 ~/weblate-env || fail "$desc"

desc='Activate the virtualenv for Weblate'
. ~/weblate-env/bin/activate || fail "$desc"

desc='Install Weblate including all dependencies'
pip install Weblate || fail "$desc"

desc='Install database driver'
pip install psycopg2-binary || fail "$desc"

desc='Install wanted optional dependencies depending on features you intend to use'
pip install django-auth-ldap tesserocr dogslow || fail "$desc"

desc='Config symlink to erebane home'
cp /home/human/erebane/translate/configs/weblate/settings.py ~/weblate-env/lib/python3.6/site-packages/weblate/settings.py || fail "$desc"

desc='pootle.conf postgres PASSWORD string marked as "secret-postgres"'
db_password=$1
sed -i "s/<weblate-postgres-password>/"$db_password"/" ~/weblate-env/lib/python3.6/site-packages/weblate/settings.py || fail "$desc"
echo "Db password: ".$db_password

desc='Create the database and its structure for Weblate'
weblate migrate || fail "$desc"

desc='Create the administrator user account and copy the password it outputs to the clipboard, and also save it for later use'
weblate createadmin || fail "$desc"

desc='Collect static files for web server'
weblate collectstatic || fail "$desc"

desc='Start Celery workers. This is not necessary for development purposes, but strongly recommended otherwise. See Background tasks using Celery for more info'
cd $HOME
~/weblate-env/lib/python3.6/site-packages/weblate/examples/celery start || fail "$desc"

desc='Start the development server (see Running server for production setup)'
weblate runserver 10.24.0.74:8664 || fail "$desc"
