#!/bin/bash

username="root"
host="127.0.0.1"
database="magento"

while :
do
    case "$1" in
      -u)
	  username="$2"
	  shift 2
	  ;;
	  -h)
	  host="$2"
	  shift 2
	  ;;
	  -d)
	  database="$2"
	  shift 2
	  ;;
      *)
	  break
	  ;;
    esac
done

stty -echo
read -p "Enter Password for user '$username'@'$host': " password
stty echo

printf "\nSTART\n"

request="SELECT DISTINCT CONCAT('SELECT DISTINCT CONCAT(\"', k.\`COLUMN_NAME\`, ' \",', k.\`COLUMN_NAME\`, ', \" exists in ', c.\`TABLE_NAME\`, ' but not exists for ', k.\`REFERENCED_COLUMN_NAME\`, ' in ', k.\`REFERENCED_TABLE_NAME\`, '\") AS \"\" FROM \`', c.\`TABLE_NAME\`, '\` WHERE \`', k.\`COLUMN_NAME\`, '\` NOT IN (SELECT \`', k.\`REFERENCED_COLUMN_NAME\`, '\` FROM \`', k.\`REFERENCED_TABLE_NAME\`, '\`);') AS \"\"
        FROM information_schema.\`TABLE_CONSTRAINTS\` c
        LEFT JOIN information_schema.\`KEY_COLUMN_USAGE\` k ON c.\`CONSTRAINT_NAME\` = k.\`CONSTRAINT_NAME\`
        WHERE c.\`CONSTRAINT_TYPE\` = 'FOREIGN KEY'  AND c.\`TABLE_SCHEMA\` = DATABASE();"

if [ -z $password ]
then
   $(mysql -u "$username" -h "$host" "$database" -e "$request" > check.tmp.sql) && $(mysql -u "$username" -h "$host" "$database" < check.tmp.sql > result.txt) && $(rm -f check.tmp.sql)
else
   $(mysql -u "$username" -p"$password" -h "$host" "$database" -e "$request" > check.tmp.sql) && $(mysql -u "$username" -p"$password" -h "$host" "$database" < check.tmp.sql > result.txt) && $(rm -f check.tmp.sql)
fi

printf "COMPLETE\n"