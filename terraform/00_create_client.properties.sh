#!/bin/bash

## Internal variables
pwd > basedir
export BASEDIR=$(cat basedir)
echo $BASEDIR

export srkey=$(echo -e "$(terraform output -raw D_01_SRKey)")
#echo $srkey
export srsecret=$(echo -e "$(terraform output -raw D_02_SRSecret)")
#echo $srsecret
export clientkey=$(echo -e "$(terraform output -raw D_05_ClientKey)")
#echo $clientkey
export clientsecret=$(echo -e "$(terraform output -raw D_06_ClientSecret)")
#echo $clientsecret
export bootstrap=$(echo -e "$(terraform output -raw A06_cc_kafka_cluster_bootsrap | sed 's/SASL_SSL:\/\///g')")
#echo $bootstrap
export srurl=$(echo -e "$(terraform output -raw A04_cc_sr_cluster_endpoint)")
#echo $srurl


echo "
bootstrap.servers=$bootstrap
security.protocol=SASL_SSL
sasl.mechanisms=PLAIN
sasl.username=$clientkey
sasl.password=$clientsecret
session.timeout.ms=45000
schema.registry.url=$srurl
basic.auth.credentials.source=USER_INFO
basic.auth.user.info=$srkey:$srsecret
group.id=genai
auto.offset.reset=earliest" > client.properties

echo "client.properties:"
cat client.properties
echo ""

echo "# Required connection configs for Kafka producer, consumer, and admin
bootstrap.servers=$bootstrap
security.protocol=SASL_SSL
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username='$clientkey' password='$clientsecret';
sasl.mechanism=PLAIN
# Required for correctness in Apache Kafka clients prior to 2.6
client.dns.lookup=use_all_dns_ips
# Best practice for higher availability in Apache Kafka clients prior to 3.0
session.timeout.ms=45000
# Best practice for Kafka producer to prevent data loss
acks=all
# Required connection configs for Confluent Cloud Schema Registry
schema.registry.url=$srurl
basic.auth.credentials.source=USER_INFO
basic.auth.user.info=$srkey:$srsecret" >  kafkatools.properties

echo ""
echo "kafkatools.properties:"
cat kafkatools.properties

# Start Terminal
echo ""
echo "Start Clients from demo...."
open -a iterm
sleep 10
osascript 01_terminals.scpt $BASEDIR
