Icinga Director Migration
=========================

This is a example repository how to achieve migration Icinga Director's data from PostgreSQL to MySQL.

ONLY use this if you know what you are doing.

## How to use

    docker-compose up -d

    pg_dump icinga_director --column-inserts --data-only > pgsql.sql

    ./import.sh

    docker exec -i $(docker-compose ps -q db) mysqldump --hex-blob -udirector -pdirector director > result.sql

## License

Public domain, NO WARRANTY, USE AT YOUR OWN RISK.
