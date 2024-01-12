#!/bin/bash

db="mydbinstance.ciruejcsilue.us-east-2.rds.amazonaws.com"

mysql -e "create database hello" -h $db -P 3306  -u admin -p  
# mysql -e "create user" 'olga'@'$db' identified by 'kaizen123'

# mysql -e "SQL_STATEMENT" -u USERNAME -pPASSWORD -h HOSTNAME -P PORT DATABASE_NAME
