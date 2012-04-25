#!/bin/bash
export S3_URL=`./get_s3_url.py $1`
./readstoredobj.rb $2
