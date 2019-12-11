# https://docs.weblate.org/en/latest/admin/install/venv-debian.html#installation
#

# System requirements
sudo apt install \
   libxml2-dev libxslt-dev libfreetype6-dev libjpeg-dev libz-dev libyaml-dev \
   libcairo-dev gir1.2-pango-1.0 libgirepository1.0-dev libacl1-dev libssl-dev \
   build-essential python3-gdbm python3-dev python3-pip python3-virtualenv virtualenv git

# optional dependencies
sudo apt install tesseract-ocr libtesseract-dev libleptonica-dev

# Web server option 1: NGINX and uWSGI
sudo apt install nginx uwsgi uwsgi-plugin-python3

# Web server option 2: Apache with ``mod_wsgi``
#apt install apache2 libapache2-mod-wsgi

# Caching backend: Redis
sudo apt install redis-server

# Database server: PostgreSQL
sudo apt install postgresql

# SMTP server
sudo apt install exim4

# Create the virtualenv for Weblate:
virtualenv --python=python3 ~/weblate-env

# Activate the virtualenv for Weblate:
. ~/weblate-env/bin/activate

# Install Weblate including all dependencies:
pip install Weblate

# Install database driver:
pip install psycopg2-binary

# Install wanted optional dependencies depending on features you intend to use (some might require additional system libraries, check Optional dependecies):
pip install tesserocr

# Copy the file
cp ~/weblate-env/lib/python3.7/site-packages/weblate/settings_example.py ~/weblate-env/lib/python3.7/site-packages/weblate/settings.py

# Adjust the values in the new settings.py file to your liking. You can stick with shipped example for testing purposes, but you will want changes for production setup, see Adjusting configuration.

# Create the database and its structure for Weblate (the example settings use SQLite, check Database setup for Weblate for pruduction ready setup):
weblate migrate

# Create the administrator user account and copy the password it outputs to the clipboard, and also save it for later use:
weblate createadmin

# Collect static files for web server (see Running server):
weblate collectstatic

# Start Celery workers. This is not necessary for development purposes, but strongly recommended otherwise. See Background tasks using Celery for more info:
~/weblate-env/lib/python3.7/site-packages/weblate/examples/celery start

# Start the development server (see Running server for production setup):
weblate runserver
