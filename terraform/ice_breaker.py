#!/usr/bin/env python
# =============================================================================
#
# Consume messages from Confluent Cloud
# Using Confluent Python Client for Apache Kafka
# Reads Avro data, integration with Confluent Cloud Schema Registry
# Call
# python icebreaker.py -f client.properties -t shoe_promotions
# avro consumer sample : https://github.com/confluentinc/examples/blob/7.5.0-post/clients/cloud/python/consumer_ccsr.py
# =============================================================================
import confluent_kafka
from confluent_kafka import DeserializingConsumer
from confluent_kafka.schema_registry import SchemaRegistryClient
from confluent_kafka.schema_registry.avro import AvroDeserializer
from confluent_kafka.serialization import StringDeserializer
import os
from langchain.prompts import PromptTemplate
from langchain_openai import ChatOpenAI
from langchain.chains import LLMChain
from tools.linkedin import scrape_linkedin_profile
from tools.linkedin_lookup_agent import lookup as linkedin_lookup_agent
import json
import ccloud_lib

OPENAIKEY = os.environ["OPENAI_API_KEY"]
PROXYCURL_API_KEY = os.environ["PROXYCURL_API_KEY"]
SERPAPI_API_KEY = os.environ["SERPAPI_API_KEY"]

if __name__ == "__main__":
    # Read arguments and configurations and initialize
    args = ccloud_lib.parse_args()
    config_file = args.config_file
    topic = args.topic
    conf = ccloud_lib.read_ccloud_config(config_file)

    schema_registry_conf = {
        "url": conf["schema.registry.url"],
        "basic.auth.user.info": conf["basic.auth.user.info"],
    }
    schema_registry_client = SchemaRegistryClient(schema_registry_conf)

    myleads_avro_deserializer = AvroDeserializer(
        schema_registry_client=schema_registry_client,
        schema_str=ccloud_lib.myleads_schema,
        from_dict=ccloud_lib.Myleads.dict_to_myleads,
    )

    # for full list of configurations, see:
    #   https://docs.confluent.io/platform/current/clients/confluent-kafka-python/#deserializingconsumer
    consumer_conf = ccloud_lib.pop_schema_registry_params_from_config(conf)
    consumer_conf["value.deserializer"] = myleads_avro_deserializer
    consumer = DeserializingConsumer(consumer_conf)

    message_count = 0
    waiting_count = 0
    # Subscribe to topic
    consumer.subscribe([topic])

    # Process messages
    while True:
        try:
            msg = consumer.poll(1.0)
            if msg is None:
                # No message available within timeout.
                # Initial message consumption may take up to
                # `session.timeout.ms` for the consumer group to
                # rebalance and start consuming
                waiting_count = waiting_count + 1
                print(
                    "{}. Waiting for message or event/error in poll(), Flink needs more data, that's why it take while to get 1 event".format(
                        waiting_count
                    )
                )
                continue
            elif msg.error():
                print("error: {}".format(msg.error()))
            else:
                myleads_object = msg.value()
                if myleads_object is not None:
                    information = myleads_object.information
                    if information is not None:
                        print(
                            "Consumed record with value {}, Total processed rows {}".format(
                                information, message_count
                            )
                        )
                        message_count = message_count + 1
                        message = (
                            "Search for information: "
                            + str(information)
                            + " with genAI ice-breaker!"
                        )
                        # Here start with genAI
                        print("Hello LangChain!")
                        try:
                            linkedin_profile_url = linkedin_lookup_agent(name=information)
                            linkedin_data = scrape_linkedin_profile(linkedin_profile_url=linkedin_profile_url)
                            # Define tasks for chatgpt
                            summary_template = """
                                given the Linkedin information {linkedin_information} about a person from I want you to create:
                                1. a short summary
                                2. two interesting facts about them
                                3. A topic that may interest them
                                4. 2 creative Ice breakers to open a conversation with them 
                            """
                            # prepare prompt (chat)
                            summary_prompt_template = PromptTemplate(
                            input_variables=["linkedin_information"],
                            template=summary_template,
                            )
                            # create chatgpt instance
                            llm = ChatOpenAI(temperature=1, model_name="gpt-3.5-turbo")
                            # LLM chain
                            chain = LLMChain(llm=llm, prompt=summary_prompt_template)
                            # execute and print result
                            print(chain.run(linkedin_information=linkedin_data))
                        except Exception as e:
                            print("An error occured:", e)
        except KeyboardInterrupt:
            break
        except SerializerError as e:
            # Report malformed record, discard results, continue polling
            print("Message deserialization failed {}".format(e))
            pass

    # Leave group and commit final offsets
    consumer.close()
