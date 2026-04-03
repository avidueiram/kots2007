#!/bin/sh
set -eu

SQL_SRC="/seed/kots_db.sql"
SQL_FIXED="/tmp/kots_db_fixed.sql"

cp "${SQL_SRC}" "${SQL_FIXED}"

# Fix known syntax issue in the legacy dump.
sed -i "/respec_points/ s/default '0'$/default '0',/" "${SQL_FIXED}"

mariadb -uroot -p"${MARIADB_ROOT_PASSWORD}" "${MARIADB_DATABASE}" < "${SQL_FIXED}"
