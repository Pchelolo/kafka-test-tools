#!/bin/bash

if [ $# -eq 0 ]; then
    echo "USAGE: start_kafka.sh start|stop|kill"
    exit 1
fi

if [ "x$KAFKA_HOME" = "x" ]; then
  echo "Please set KAFKA_HOME env variable to the kafka install directory"
  exit 1
fi

if [ ! -x "$(command -v nc)" ]; then
  echo "Please install Netcat (nc) first"
  exit 1
fi

if [ ! -x "$(command -v java)" ]; then
  echo "Please install Java 1.8 or higher first"
  exit 1
fi

major_version=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
minor_version=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f2)

if [ $((major_version + 0)) -lt 2 -a $((minor_version + 0)) -lt 8 ]; then
  echo "Java 1.8 or higher is required. Found Java $major_version.$minor_version"
  exit 1
fi

if [ "$1" = "start" ]; then
  if [ `nc localhost 2181 < /dev/null; echo $?` != 0 ]; then
    sh $KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties > /dev/null &
    while [ `nc -z localhost 2181; echo $?` != 0 ]; do
      echo "waiting for Zookeeper..."
      sleep 1 ;
    done
  else
    echo "Zookeper already running"
  fi

  if [ `nc localhost 9092 < /dev/null; echo $?` != 0 ]; then
    sh $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties > /dev/null &
    while [ `nc -z localhost 9092; echo $?` != 0 ]; do
      echo "waiting for Kafka..." ;
      sleep 1 ;
    done
  else
    echo "Kafka already running";
  fi
elif [ "$1" = "stop" ]; then
  sh $KAFKA_HOME/bin/kafka-server-stop.sh &
  sh $KAFKA_HOME/bin/zookeeper-server-stop.sh &
elif [ "$1" = "kill" ]; then
  ps ax | grep -i 'kafka\.Kafka' | grep java | grep -v grep | awk '{print $1}' | xargs kill -SIGKILL 2>/dev/null &
  ps ax | grep -i 'zookeeper' | grep -v grep | awk '{print $1}' | xargs kill -SIGKILL 2>/dev/null &
fi
