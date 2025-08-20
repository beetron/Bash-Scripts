#!/bin/bash

set -e

# Location for this script
SCRIPT_DIRECTORY="/home/username/docker_mongodb"

# CD to script's directory (for cron compatibility)
cd "$SCRIPT_DIRECTORY"

# Other environment variables to set
BACKUP_FILENAME_SUFFIX="-backupMongo.tgz"

OLD_BACKUP_FILES=(*"$BACKUP_FILENAME_SUFFIX")
BACKUP_FILENAME="$(date +%Y-%m%d-%H%M)$BACKUP_FILENAME_SUFFIX"

# Create a temp directory for the backup
TMPDIR="$(mktemp -d)"
trap "rm -rf $TMPDIR" EXIT

# Get the running MongoDB container ID
CONTAINER_ID=$(docker ps --filter "name=mongodb" --format "{{.ID}}" | head -n 1)
if [ -z "$CONTAINER_ID" ]; then
  echo "No running container found with 'mongodb' in its name."
  exit 1
fi

# Retrieve MongoDB credentials from secrets in the container
USERNAME=$(docker exec "$CONTAINER_ID" cat /run/secrets/mongo_root_username)
PASSWORD=$(docker exec "$CONTAINER_ID" cat /run/secrets/mongo_root_password)

# Run mongodump inside the container, outputting to /tmp
docker exec "$CONTAINER_ID" mongodump \
  --uri="mongodb://$USERNAME:$PASSWORD@localhost:27017/" \
  --out /tmp/mongodump

# Copy the mongodump from the container to the host's temp directory
docker cp "$CONTAINER_ID":/tmp/mongodump "$TMPDIR"

# Create the archive in the script directory
tar -czf "$BACKUP_FILENAME" -C "$TMPDIR/mongodump" .

# Remove all previous backup files (that existed before this run)
for f in "${OLD_BACKUP_FILES[@]}"; do
  if [[ "$f" != "$BACKUP_FILENAME" && -f "$f" ]]; then
    echo "Deleting previous backup: $f"
    rm -f -- "$f"
  fi
done

echo "Backup complete: $BACKUP_FILENAME"
