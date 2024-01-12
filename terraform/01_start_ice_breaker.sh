#!/bin/bash
# Set title
export PROMPT_COMMAND='echo -ne "\033]0;Start ICE-BREAKER Client\007"'
echo -e "\033];Consume from Confluent Cloud salesforce_myleads topic\007"

# Consume raw events Terminal 1
echo "Consume from Confluent Cloud salesforce_myleads topic (ice_breaker langchain LLM AI): "
source env-vars
python3 ice_breaker.py -f client.properties -t salesforce_myleads