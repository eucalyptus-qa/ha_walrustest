#!/bin/bash
export S3_URL=`./get_s3_url.py $1`
./gettest.rb
