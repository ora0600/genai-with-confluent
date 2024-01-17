#!/usr/bin/env python
# =============================================================================
#
# Helper module
# Orginal source code https://github.com/confluentinc/examples/blob/7.5.0-post/clients/cloud/python/ccloud_lib.py
# =============================================================================

import argparse, sys
from confluent_kafka import avro, KafkaError
from jproperties import Properties

# Schema used for serializing Count class, passed in as the Kafka value
myleads_schema = """
{
  "fields": [
    {
      "default": null,
      "name": "saluation",
      "type": [
        "null",
        "string"
      ]
    },
    {
      "default": null,
      "name": "firstname",
      "type": [
        "null",
        "string"
      ]
    },
    {
      "default": null,
      "name": "lastname",
      "type": [
        "null",
        "string"
      ]
    },
    {
      "default": null,
      "name": "information",
      "type": [
        "null",
        "string"
      ]
    },
    {
      "default": null,
      "name": "email",
      "type": [
        "null",
        "string"
      ]
    },
    {
      "default": null,
      "name": "company",
      "type": [
        "null",
        "string"
      ]
    }
  ],
  "name": "record",
  "namespace": "org.apache.flink.avro.generated",
  "type": "record"
}
"""

mycalls_schema = """
{
  "fields": [
    {
      "default": null,
      "name": "saluation",
      "type": [
        "null",
        "string"
      ]
    },
    {
      "default": null,
      "name": "firstname",
      "type": [
        "null",
        "string"
      ]
    },
    {
      "default": null,
      "name": "lastname",
      "type": [
        "null",
        "string"
      ]
    },
    {
      "default": null,
      "name": "email",
      "type": [
        "null",
        "string"
      ]
    },
    {
      "default": null,
      "name": "company",
      "type": [
        "null",
        "string"
      ]
    },
    {
      "default": null,
      "name": "facts",
      "type": [
        "null",
        "string"
      ]
    }
  ],
  "name": "record",
  "namespace": "org.apache.flink.avro.generated",
  "type": "record"
}
"""


class Myleads(object):
    # Use __slots__ to explicitly declare all data members.
    __slots__ = [
        "saluation",
        "firstname",
        "lastname",
        "information",
        "email",
        "company"
    ]

    def __init__(
        self,
        saluation=None,
        firstname=None,
        lastname=None,
        information=None,
        email=None,
        company=None
    ):
        self.saluation = saluation
        self.firstname = firstname
        self.lastname = lastname
        self.information = information
        self.email = email
        self.company = company

    @staticmethod
    def dict_to_myleads(obj, ctx):
        if obj is None:
            return None
        return Myleads(
            saluation=obj["saluation"],
            firstname=obj["firstname"],
            lastname=obj["lastname"],
            information=obj["information"],
            email=obj["email"],
            company=obj["company"]
        )

    @staticmethod
    def myleads_to_dict(myleads, ctx):
        return dict(saluation=myleads.saluation, firstname=myleads.firstname, lastname=myleads.lastname, information=myleads.information, email=myleads.lastname, company=myleads.company)

# myCalls
class Mycalls(object):
    # Use __slots__ to explicitly declare all data members.
    __slots__ = [
        "saluation",
        "firstname",
        "lastname",
        "email",
        "company",
        "facts"
    ]

    def __init__(
        self,
        saluation=None,
        firstname=None,
        lastname=None,
        email=None,
        company=None,
        facts=None
    ):
        self.saluation = saluation
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.company = company
        self.facts = facts

    @staticmethod
    def dict_to_mycalls(obj, ctx):
        if obj is None:
            return None
        return Mycalls(
            saluation=obj["saluation"],
            firstname=obj["firstname"],
            lastname=obj["lastname"],
            email=obj["email"],
            company=obj["company"],
            facts=obj["facts"]
        )

    @staticmethod
    def mycalls_to_dict(mycalls, ctx):
        return dict(saluation=mycalls.saluation, firstname=mycalls.firstname, lastname=mycalls.lastname, email=mycalls.lastname, company=mycalls.company, facts=mycalls.facts)

def parse_args():
    """Parse command line arguments"""

    parser = argparse.ArgumentParser(
        description="Confluent Python Client example to consume messages to Confluent Cloud"
    )
    parser._action_groups.pop()
    required = parser.add_argument_group("required arguments")
    required.add_argument(
        "-f",
        dest="config_file",
        help="path to Confluent Cloud configuration file",
        required=True,
    )
    required.add_argument(
        "-from", dest="fromtopic", help="from topic name", required=True
    )
    required.add_argument("-to", dest="totopic", help="to topic name", required=True)
    args = parser.parse_args()

    return args


def read_ccloud_config(config_file):
    """Read Confluent Cloud configuration for librdkafka clients"""

    conf = {}
    with open(config_file) as fh:
        for line in fh:
            line = line.strip()
            if len(line) != 0 and line[0] != "#":
                parameter, value = line.strip().split("=", 1)
                conf[parameter] = value.strip()

    return conf


def pop_schema_registry_params_from_config(conf):
    """Remove potential Schema Registry related configurations from dictionary"""

    conf.pop("schema.registry.url", None)
    conf.pop("basic.auth.user.info", None)
    conf.pop("basic.auth.credentials.source", None)

    return conf
