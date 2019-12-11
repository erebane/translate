#!/bin/bash
#
# Remove weblate installation db
#
# - Remove postgresql db weblate
# - Remove postgres db user weblate
#

output_error="Weblate db remove ERROR: "
output_ok="Weblate db remove OK: "
output_end=""

# Remove db weblate
sudo su postgres -c "dropdb weblate"

# Remove postgres db user weblate
sudo su postgres -c "dropuser weblate"

