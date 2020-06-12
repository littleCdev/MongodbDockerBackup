#!/bin/sh

# backupname is $Databasename_$TIMESTAMP
BACKUP_LOCATION="/home//backup/mongodb/"
TIMESTAMP=$(date +'%Y%m%d%H')

#mongodb host
MONGOHOST="localhost"
MONGOPORT=27017

# databases to backup
# use all or specify but not both
BACKUP_ALL=true
DATABASES_TO_EXCLUDE=("admin" "config" "local");
# or specify some databases here
DATABASES_TO_BACKUP=();

# docker container
DOCKER_NAME="mongobackup"

#check if only one option is used (all dbs or specified)
if [ ${#DATABASES_TO_BACKUP[@]} -gt 0 -a ${BACKUP_ALL} = true ] ; then
 echo "you can not use BACKUP_ALL=true and DATABASES_TO_BACKUP at the same time!"
 echo "set BACKUP_ALL to false or empty DATABASES_TO_BACKUP"
 exit
fi

#get latest docker image for mongodb
docker pull --quiet mongo

#create container with given name if it does not exist
[[ $(docker ps -f "name=${DOCKER_NAME}" --format '{{.Names}}') == "${DOCKER_NAME}" ]] ||
docker run --name "${DOCKER_NAME}" -d mongo


# get all databases from mongodb
if [ ${BACKUP_ALL} = true ] ; then
  while read line; do
     ar=($line);
     databasename=${ar[0]};
    if [[ ! " ${DATABASES_TO_EXCLUDE[@]} " =~ " ${databasename} " ]]; then
      DATABASES_TO_BACKUP+=($databasename)
    fi
  done <<< $(docker exec $DOCKER_NAME sh -c "exec echo show dbs| mongo -quiet --host=${MONGOHOST} --port=${MONGOPORT}")
fi

# backup all filtered databases
for database in "${DATABASES_TO_BACKUP[@]}"
do
   :
   echo "backup for ${database}"
   docker exec $DOCKER_NAME sh -c "exec mongodump --host=${MONGOHOST} --port=${MONGOPORT} -d ${database} --archive" > "${BACKUP_LOCATION}${databasename}_${TIMESTAMP}"
done









