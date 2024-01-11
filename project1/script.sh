#!/bin/bash

db="mydbinstance.ciruejcsilue.us-east-2.rds.amazonaws.com"

mysql -e "create database four" -h $db -u admin -p
mysql -e "create user" 'olga'@'$db' identified by 'kaizen123'

