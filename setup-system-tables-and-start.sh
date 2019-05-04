#!/bin/bash

COUCHDB_USER_AND_PASS_AND_PROTOCOL=$(echo $SECRETIN_SERVER_COUCHDB_URL | awk -F "@" '{print $1}')
COUCHDB_USER_AND_PASS=$(echo $COUCHDB_USER_AND_PASS_AND_PROTOCOL | awk -F "//" '{print $2}')
COUCHDB_ADMIN_USERNAME=$(echo $COUCHDB_USER_AND_PASS | awk -F ":" '{print $1}')
COUCHDB_ADMIN_PASSWORD=$(echo $COUCHDB_USER_AND_PASS | awk -F ":" '{print $2}')

COUCHDB_HOST_END=$(echo $SECRETIN_SERVER_COUCHDB_URL | awk -F "@" '{print $2}')
COUCHDB_HOST_END=$(echo $COUCHDB_HOST_END | awk -F "/" '{print $1}')
COUCHDB_HOST_BEGIN=$(echo $COUCHDB_USER_AND_PASS_AND_PROTOCOL | awk -F ":" '{print $1}')
COUCHDB_HOST=$COUCHDB_HOST_BEGIN://$COUCHDB_HOST_END

until curl $COUCHDB_HOST
do
  sleep 1
done

curl -X PUT $COUCHDB_HOST/_config/admins/$COUCHDB_ADMIN_USERNAME -d \"$COUCHDB_ADMIN_PASSWORD\"

curl -X PUT $COUCHDB_HOST/_global_changes
curl -X PUT $COUCHDB_HOST/_metadata
curl -X PUT $COUCHDB_HOST/_replicator
curl -X PUT $COUCHDB_HOST/_users

yarn start
