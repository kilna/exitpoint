#!/bin/sh

set -e -u

# Get the latest image versions numbers for alpine and busybox and append an
# entry to CHANGELOG.yaml

# Fetch the latest version numbers for alpine and busybox
alpine_info="$(
  curl -s https://registry.hub.docker.com/v2/repositories/library/alpine/tags \
    | jq -r '.results[] | select(.name | test("^[0-9]+\\.[0-9]+\\.[0-9]+$")) | "\(.name) \(.last_updated)"' \
    | sort -V \
    | tail -n 1
)"
alpine_version=$(echo "$alpine_info" | awk '{print $1}')
alpine_date=$(echo "$alpine_info" | awk '{print $2}' | cut -d'T' -f1)
echo "alpine_version: $alpine_version"
echo "alpine_date: $alpine_date"

busybox_info="$(
  curl -s https://registry.hub.docker.com/v2/repositories/library/busybox/tags \
    | jq -r '.results[] | select(.name | test("^[0-9]+\\.[0-9]+\\.[0-9]+-glibc$")) | "\(.name) \(.last_updated)"' \
    | sort -V \
    | tail -n 1
)"
busybox_version=$(echo "$busybox_info" | awk '{print $1}' | sed 's/-glibc//')
busybox_date=$(echo "$busybox_info" | awk '{print $2}' | cut -d'T' -f1)
echo "busybox_version: $busybox_version"
echo "busybox_date: $busybox_date"

# Read the most recent version number from CHANGELOG.yml using yq
latest_version=$(
  grep -oP '^v\K[0-9]+\.[0-9]+\.[0-9]+' CHANGELOG.yml \
    | sort -V \
    | tail -n 1
)

# Increment the fix version
IFS='.' read -r major minor fix <<< "$latest_version"
fix=$((fix + 1))

# Add a new entry to CHANGELOG.yml
cat <<EOL >> CHANGELOG.yml
v$major.$minor.$fix:
  date: $(date +%Y-%m-%d)
  description: |
    Updated:
    * alpine to $alpine_version ($alpine_date)
    * busybox to $busybox_version ($busybox_date)
EOL
