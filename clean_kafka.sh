#!/bin/bash

dropTopics ( ) {
  if [ "$#" -eq 1 ]
  then
    PATTERN=$1
    echo "looking for topics named '*${PATTERN}*'..."
    TOPICS=`${KAFKA_HOME}/bin/kafka-topics.sh --zookeeper localhost:2181 --list \
    	| grep ${PATTERN} \
    	| grep -v 'marked for deletion$'`
    for TOPIC in ${TOPICS}
    do
      echo "dropping topic ${TOPIC}" && \
        ${KAFKA_HOME}/bin/kafka-topics.sh --zookeeper localhost:2181 --delete --topic ${TOPIC} > /dev/null &
    done
    wait
  fi
}

createTopic ( ) {
    echo "Creating topic ${1}"
    ${KAFKA_HOME}/bin/kafka-topics.sh --create \
        --zookeeper 127.0.0.1:2181             \
        --partitions 1                         \
        --replication-factor 1                 \
        --topic $1 > /dev/null &
}

check ( ) {
  PORT=$1
  SERVICE_NAME=$2
  if [ `nc -z localhost ${PORT}; echo $?` != 0 ]; then
    echo "${SERVICE_NAME} not running, start it first with npm run start-kafka"
    exit 1
  fi
}
