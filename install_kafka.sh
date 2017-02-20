#!/bin/bash

if [ "x$KAFKA_HOME" = "x" ]; then
  echo "Please set KAFKA_HOME env variable to the kafka install directory"
  exit 1
fi

if [ "x$KAFKA_VERSION" = "x" ]; then
  echo "Please set KAFKA_VERSION env variable to the kafka version number"
  exit 1
fi

wget http://www.us.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_2.10-${KAFKA_VERSION}.tgz -O kafka.tgz
mkdir -p ${KAFKA_HOME} && tar xzf kafka.tgz -C ${KAFKA_HOME} --strip-components 1
echo 'delete.topic.enable=true' >> ${KAFKA_HOME}/config/server.properties