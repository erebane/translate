#!/bin/bash
#
# Pootle installation and initial config
#
#   Create python virtual environment for pootle
#   Install pootle via pip
#   Start rq worker
#   Init & migrate db
#
# @url http://docs.translatehouse.org/projects/pootle/en/stable-2.8.x/server/installation.html
# @url https://translate.hajaan.nu
#
output_error="Pootle ERROR: "
output_ok="Pootle OK: "
output_end=""


# Create python virtual environment for pootle
virtualenv /opt/pootle/env
source /opt/pootle/env/bin/activate

# Install pootle via pip
pip install --upgrade pip setuptools
pip install --process-dependency-links Pootle[postgresql]
pip install --pre --process-dependency-links Pootle[es5]
pip install elasticsearch

# Set symlink to config @ /opt/translate/configs/pootle/
ln -s /opt/translate/configs/pootle/pootle.conf /opt/pootle/env/

# Generate secret-key for pootle.conf SECRET_KEY
secret_key=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)

# pootle.conf SECRET_KEY password string marked as "secret-key"
sed -i "s/secret-key/"$secret_key"/" /opt/pootle/env/pootle.conf
echo "New secret: ".$secret_key

# pootle.conf postgres PASSWORD string marked as "secret-postgres"
db_password=$1
sed -i "s/secret-postgres/"$db_password"/" /opt/pootle/env/pootle.conf
echo "Db password: ".$db_password

echo -e $output_error'SMTP password "secret-hajaannu-mail" UNSET, set MANUALLY.'$output_end

# Start rq worker
pootle rqworker &> /tmp/rqworker.log &

# Init & migrate db
pootle migrate
pootle initdb
