#!/bin/bash
#
# Remove pootle installation db and folders
#
# - Remove postgresql db pootle
# - Remove postgres db user pootle
# - Remove installation folder /opt/pootle/
# - Remove system user pootle and its home
#

output_error="Pootle remove ERROR: "
output_ok="Pootle remove OK: "
output_end=""

# Remove db pootle
sudo su postgres -c "dropdb pootle"

# Remove postgres db user pootle
sudo su postgres -c "dropuser pootle"

# Remove installation folder /opt/pootle/
sudo rm -rf /opt/pootle
sudo rm -rf /opt/pootle-projects

# Remove system user pootle and its home
sudo deluser --remove-home pootle
