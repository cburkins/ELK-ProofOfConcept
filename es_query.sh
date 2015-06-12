#!/bin/bash

curl --silent -XGET 'http://localhost:9200/logstash-*/_search?q=_type:nbu_job' | python -m json.tool | grep total

