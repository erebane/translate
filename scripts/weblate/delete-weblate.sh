#!/bin/bash
#
# Remove weblate installation db and system user
#
# - Remove postgresql db weblate
# - Remove postgres db user weblate
# - Remove system user translate and its home

# Remove db weblate
sudo su postgres -c "dropdb weblate"

# Remove postgres db user weblate
sudo su postgres -c "dropuser weblate"

# Remove system user translate and its home
sudo deluser --remove-home translate
