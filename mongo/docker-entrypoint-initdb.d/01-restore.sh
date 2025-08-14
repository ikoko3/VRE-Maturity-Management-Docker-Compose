#!/bin/sh
set -e

ARCHIVE="/docker-entrypoint-initdb.d/seed.archive.gz"

echo "Seeding MongoDB from $ARCHIVE ..."

AUTH=""
if [ -n "${MONGO_INITDB_ROOT_USERNAME:-}" ]; then
  AUTH="--username=$MONGO_INITDB_ROOT_USERNAME --password=$MONGO_INITDB_ROOT_PASSWORD --authenticationDatabase=admin"
fi

mongorestore $AUTH --drop --archive="$ARCHIVE" --gzip

echo "Seeding complete."
