#!/bin/bash

set -ex

if [ ! -e director-base.sql ]; then
  wget https://github.com/Icinga/icingaweb2-module-director/raw/v1.3.1/schema/mysql.sql -O director-base.sql
fi

CONTAINER=$(docker-compose ps -q db)

docker exec -i "$CONTAINER" mysql -udirector -pdirector director -e "DROP DATABASE director; CREATE DATABASE director;"

docker exec -i "$CONTAINER" mysql -udirector -pdirector director < director-base.sql

# Update schema:
# 1. Disable all SET and SELECT (autoincrement updates)
# 2. Convert datetime
# 3. Convert binary BLOBs

cat pgsql.sql \
  | perl -pe 's/^(SET|SELECT)/-- \1/g' \
  | perl -pe "s/'(\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d)(\.\d+)?\+00'/'\1'/g" \
  | perl -pe "s/'\\\x([a-f0-9]+)'/0x\U\1\E/g" \
  > mysql.sql

docker exec -i "$CONTAINER" mysql -udirector -pdirector director < mysql.sql

# vi: ts=2 sw=2 expandtab :
