# kafka-test-tools

Package contain several util scripts useful in testing services
dependent on Apache Kafka.

1. `install_kafka.sh` - downloads and installs kafka distribution. 
    Requires `KAFKA_HOME` environment variable to be set to the install
    target location and `KAFKA_VERSION` environment variable to specify
    kafka version string.
2. `clean_kafka.sh` - contains several functions to check whether kafka 
    is running, drop topics and create topics.
3. `start_kafka.sh` - starts Zookeeper and Kafka and waits for them to 
    be ready.