#!/bin/bash

db="mydbinstance.ciruejcsilue.us-east-2.rds.amazonaws.com"

mysql -e "create database kaizen" -h $db -P 3306  -u admin -p  
