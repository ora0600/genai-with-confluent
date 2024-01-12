#!/bin/bash
# Set title
export PROMPT_COMMAND='echo -ne "\033]0;Consume from Confluent Cloud salesforce_myleads topic\007"'
echo -e "\033];Consume from Confluent Cloud salesforce_myleads topic\007"

# Consume raw events Terminal 1
echo "Consume from Confluent Cloud salesforce_myleads topic: "
kafka-avro-console-consumer --bootstrap-server  $(awk '/bootstrap.servers=/{print $NF}' kafkatools.properties | cut -d'=' -f 2) --topic salesforce_myleads \
 --consumer.config ./kafkatools.properties \
 --property basic.auth.credentials.source=USER_INFO \
 --property schema.registry.url=$(awk '/schema.registry.url=/{print $NF}'  kafkatools.properties | cut -d'=' -f 2) \
 --property schema.registry.basic.auth.user.info=$(awk '/basic.auth.user.info=/{print $NF}' kafkatools.properties | cut -d'=' -f 2)
