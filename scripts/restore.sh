#!/usr/bin/env bash

set -e -u -o pipefail

[ -v PTFE_PRIVATE_IP ] || PTFE_PRIVATE_IP="192.168.56.33"
[ -v PTFE_PUBLIC_IP ] || PTFE_PUBLIC_IP="0.0.0.0"
[ -v PATH ] || PATH="/var/lib/replicated/snapshots"

access="--store local --path $PATH"

# jq is used by this script, so install it. For other Linux distros, either preinstall jq
# and remove these lines, or change to the mechanism your distro uses to install jq.

which jq || {
    sudo apt-get update
    sudo apt-get install -y jq
}

# Check if replicated is installed
systemctl is-active replicated.service
Run the installer.

curl https://install.terraform.io/ptfe/stable | bash -s fast-timeouts private-address=${PTFE_PRIVATE_IP} public-address=${PTFE_PUBLIC_IP}

# This retrieves a list of all the snapshots currently available.
replicatedctl snapshot ls $access -o json > /tmp/snapshots.json

# Pull just the snapshot id out of the list of snapshots
id=$(jq -r 'sort_by(.finished) | .[-1].id // ""' /tmp/snapshots.json)

# If there are no snapshots available, exit out
if test "$id" = ""; then
  echo "No snapshots found"
  exit 1
fi

echo "Restoring snapshot: $id"

# Restore the detected snapshot. This ignores preflight checks to be sure the application
# is booted.
replicatedctl snapshot restore $access --dismiss-preflight-checks "$id"

# Wait until the application reports itself as running. This step can be removed if
# something upstream is prepared to wait for the application to finish booting.
until curl -f -s --connect-timeout 1 http://localhost/_health_check; do
  sleep 1
done

echo
echo "Application booted!"