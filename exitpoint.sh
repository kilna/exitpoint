#!/bin/sh

cat <<EOF
Error: Default /exitpoint.sh script has no action.

This container image was designed such that it will run the /exitpoint.sh
script after Docker's CMD has completed and before shutdown is complete.

You can override the default exitpoint script location by setting the EXITPOINT
environment variable.

CMD_EXIT was $CMD_EXIT
EOF

exit 1

