#!/bin/bash

# : "${FORKED:=}"
# if [ -z "${FORKED}" ]; then
# 	echo >&2 'mongod for initdb is going to shutdown'
# 	mongod --pidfilepath /tmp/docker-entrypoint-temp-mongod.pid --shutdown
# 	echo >&2 'replica set will be initialized later'
# 	FORKED=1 "${BASH_SOURCE[0]}" &
# 	unset FORKED
# 	mongodHackedArgs=(:) # bypass mongod --shutdown in docker-entrypoint.sh
# 	return
# fi

mongo=( mongo --host mongo-rs1 --port 27041 )

# tries=30
# while true; do
# 	sleep 1
# 	if "${mongo[@]}" --eval 'quit(0)' &> /dev/null; then
# 		# success!
# 		break
# 	fi
# 	(( tries-- ))
# 	if [ "$tries" -le 0 ]; then
# 		echo >&2 " ==X== "
# 		echo >&2 'error: unable to initialize replica set'
# 		echo >&2 " ==X== "
# 		kill -STOP 1 # initdb won't be executed twice, so fail loudly
# 		exit 1
# 	fi
# done

echo ' ===== '
echo 'about to initialize replica set'
echo ' ===== '
sleep 5
# FIXME: hard-coded replica set name & member host
mongo mongo-rs1:27041 --eval 'rs.initiate({ "_id": "RS", "members": [{ "_id": 0, "host": "mongo-rs1:27041", "priority": 1 }, { "_id": 1, "host": "mongo-rs2:27042", "priority": 0 }, { "_id": 2, "host": "mongo-rs3:27043", "priority": 0 } ] });'
sleep 5

echo ' ===== '
echo 'complete replica set initiation'
echo ' ===== '

mongo mongo-rs1:27041 --eval 'rs.status()'

# echo ' ===== '
# echo 'about to initialize replica set'
# echo ' ===== '
# mongo mongo-rs1:27041 --file /scripts/init.js