#!/bin/bash
system_user_connect_url=`grep 'system.sqlplus.url' ./flyway.conf |cut -d'=' -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
connection_string=`grep 'flyway.url' ./flyway.conf |cut -d'=' -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
connect_url=`echo $connection_string | cut -d':' -f 4`
connect_url="$connect_url:"`echo $connection_string | cut -d':' -f 5`
user=`echo $connection_string | cut -d':' -f 4 | cut -d'/' -f 1`
password=`echo $connection_string | cut -d':' -f 4 | cut -d'/' -f 2 | cut -d'@' -f 1`

echo "Creating User: $user with password: $password and schema: $schema"
echo "Connect URL: $connect_url"

sqlplus -S /nolog <<EOF
CONNECT $system_user_connect_url
set feedback off
alter session set "_oracle_script"=true;
CREATE USER $user IDENTIFIED BY $user;
GRANT ALL PRIVILEGES TO $user;
GRANT IMP_FULL_DATABASE TO $user;
EXIT;
EOF
