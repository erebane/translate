#!/bin/bash
#
# Remove https://translate.heikkihakala.fi pootle
#
# 1. Remove postgresql db pootle
# 2. Remove postgres db user pootle
# 3. Remove installation folder /opt/pootle/
# 4. Remove system user pootle and its home
#

output_error="Pootle remove ERROR: "
output_ok="Pootle remove OK: "
output_end=""

# 1. Remove db pootle
sudo su postgres -c "dropdb pootle"

# 2. Remove postgres db user pootle
sudo su postgres -c "dropuser pootle"

# 3. Remove installation folder /opt/pootle/
sudo rm -rf /opt/pootle
sudo rm -rf /opt/pootle-projects

# 4. Remove system user pootle and its home
sudo deluser --remove-home pootle
