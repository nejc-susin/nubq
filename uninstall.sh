#! /bin/bash

# This script removes the NubQ files, but keeps the job logs.

ROOT='/nubq'

rm -rf "$ROOT/nubq"

sudo userdel q

# TODO: remove entries from /etc/bash.bashrc and /etc/profile as well

echo "NubQ was uninstalled. The logs were left untouched in $ROOT."
