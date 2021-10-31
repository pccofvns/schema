#!/bin/bash
system_user_connect_url=`grep 'system.sqlplus.url' ./flyway.conf |cut -d'=' -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
connection_string=`grep 'flyway.url' ./flyway.conf |cut -d'=' -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
connect_url=`echo $connection_string | cut -d':' -f 4`
connect_url="$connect_url:"`echo $connection_string | cut -d':' -f 5`
user=`echo $connection_string | cut -d':' -f 4 | cut -d'/' -f 1`

echo "Dropping User: $user"

sqlplus -S /nolog <<EOF
CONNECT $system_user_connect_url
alter session set "_oracle_script"=true;
DROP USER $user CASCADE;
EXIT;
EOF
