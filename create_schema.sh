#!/bin/bash
connection_string=`grep 'flyway.url' ./flyway.conf |cut -d'=' -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
connect_url=`echo $connection_string | cut -d':' -f 4`
connect_url="$connect_url:"`echo $connection_string | cut -d':' -f 5`

echo "Running base db scripts...."
echo "sql $connect_url @base.sql"
# neohix/neohix@//localhost:1521/XE
cd src/main/resources/db/base
sql -S /nolog <<EOF
CONNECT $connect_url
@base;
EXIT;
EOF
echo "Completed running scripts."
cd ../../../../..
