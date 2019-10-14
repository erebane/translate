#!/bin/bash
#
# Pootle installation and initial config
#
# - Install packages
# - Add pootle system user
# - Add postgresql user pootle
# - Create db pootle
# - Create folder /opt/pootle and right to user pootle
# - Create folder /opt/pootle-projects and rights to user pootle
# - Install python virtualenv as user pootle
#
# @url http://docs.translatehouse.org/projects/pootle/en/stable-2.8.x/server/installation.html
# @url https://translate.hajaan.nu
#
output_error="Pootle ERROR: "
output_ok="Pootle OK: "
output_end=""

# Install packages
sudo apt-get install build-essential libxml2-dev libxslt-dev python-dev python-pip zlib1g-dev postgresql-server-dev-9.5 python-virtualenv
sudo -H pip install virtualenv psycopg2

# Add pootle system user
sudo adduser --disabled-login --gecos 'pootle' pootle
if [ $? -ne 0 ]; then
    echo -e $output_error'Add system user pootle FAILED.'$output_end
    exit
fi

# Add postgresql user pootle
sudo su postgres -c "createuser --no-superuser --createdb --no-createrole pootle"
if [ $? -ne 0 ]; then
    echo -e $output_error'Create postgres database user "pootle" FAILED.'$output_end
    exit
fi

# Generate random 15 character alphanumeric string (upper and lowercase)
db_password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
sudo -u postgres psql -a -U postgres -d postgres -c "ALTER USER pootle WITH PASSWORD '"$db_password"'"
if [ $? -ne 0 ]; then
    echo -e $output_error'Setting password for database user "pootle" FAILED.'$output_end
    exit
fi

# Create db pootle
sudo su postgres -c "createdb --encoding='utf8' --locale=en_US.utf8 --template=template0 --owner=pootle pootle"
if [ $? -ne 0 ]; then
    echo -e $output_error'Create pootle database FAILED.'$output_end
    exit
fi

# Create folder /opt/pootle and right to user pootle
sudo mkdir /opt/pootle && sudo chown pootle:pootle /opt/pootle/
if [ $? -ne 0 ]; then
    echo -e $output_error'Create install folder or setting its permissions FAILED.'$output_end
    exit
fi

# Create folder /opt/pootle-projects and rights to user pootle
sudo mkdir /opt/pootle-projects && sudo chown pootle:pootle /opt/pootle-projects
if [ $? -ne 0 ]; then
    echo -e $output_error'Create pootle project folder or setting its permissions FAILED.'$output_end
    exit
fi

# Install virtualenv as user pootle
sudo su pootle -c '/opt/translate/scripts/install_pootle_user_pootle.sh '$db_password
if [ $? -ne 0 ]; then
    echo -e $output_error'Installation script as user pootle FAILED.'$output_end
    exit
else
    echo -e $output_ok' OK.'$output_end
fi
