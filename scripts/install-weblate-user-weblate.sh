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
