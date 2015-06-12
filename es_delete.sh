#!/bin/bash

echo 
echo "   You're about to DELETE lots of data from ElasticSearch"
echo 

echo "Hit <return> to continue..."
read
echo
echo "Go..."
echo 
sleep 1
echo

curl -XDELETE 'http://localhost:9200/logstash-*/nbu_job'

