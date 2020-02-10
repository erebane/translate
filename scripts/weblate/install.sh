# Weblate installation script
# @URL: https://docs.weblate.org/en/latest/admin/install/venv-debian.html#installation
#

fail () {
    /opt/hajaannu/bin/bash-logger --msg "$desc"
    exit
}

desc='System requirements'
sudo apt install \
   libxml2-dev libxslt-dev libfreetype6-dev libjpeg-dev libz-dev libyaml-dev \
   libcairo-dev gir1.2-pango-1.0 libgirepository1.0-dev libacl1-dev libssl-dev \
   build-essential python3-gdbm python3-dev python3-pip python3-virtualenv virtualenv git \
|| fail "$desc"

desc='optional dependencies'
sudo apt install tesseract-ocr libtesseract-dev libleptonica-dev || fail "$desc"

desc='Web server option 1: NGINX and uWSGI'
sudo apt install nginx uwsgi uwsgi-plugin-python3 || fail "$desc"

desc='Caching backend: Redis'
sudo apt install redis-server || fail "$desc"

desc='Database server: PostgreSQL'
sudo apt install postgresql || fail "$desc"

desc='SMTP server'
sudo apt install exim4 || fail "$desc"

desc='Add postgresql user weblate'
(sudo su postgres -c "createuser --no-superuser --createdb --no-createrole weblate") || fail "$desc"

desc='Generate random 15 character alphanumeric string (upper and lowercase)'
db_password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9'| fold -w 15 | head -n 1) || fail "desc"

desc='Set postgresql password for user weblate'
sudo -u postgres psql -a -U postgres -d postgres -c "ALTER USER weblate WITH PASSWORD '"$db_password"'" || fail "desc"

desc='Create db weblate'
sudo su postgres -c "createdb --encoding='utf8' --locale=en_US.utf8 --template=template0 --owner=weblate weblate" || fail "desc"

desc='Install weblate as user cn=weblate,ou=app,dc=hajaan,dc=nu'
sudo su weblate -c '/home/human/erebane/translate/scripts/weblate/install-user-weblate.sh '$db_password || fail "desc"
