# --------------------------------------------------------
# Service Accounts (Connectors)
# --------------------------------------------------------
resource "confluent_service_account" "connectors" {
  display_name = "connectors-${random_id.id.hex}"
  description  = local.description
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Access Control List (ACL)
# --------------------------------------------------------
resource "confluent_kafka_acl" "connectors_source_describe_cluster" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}
# Demo topics
resource "confluent_kafka_acl" "connectors_source_create_topic_demo" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "TOPIC"
  resource_name = "salesforce_"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = "CREATE"
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_kafka_acl" "connectors_source_write_topic_demo" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "TOPIC"
  resource_name = "salesforce_"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = "WRITE"
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_kafka_acl" "connectors_source_read_topic_demo" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "TOPIC"
  resource_name = "salesforce_"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = "READ"
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}
# DLQ topics (for the connectors)
resource "confluent_kafka_acl" "connectors_source_create_topic_dlq" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "TOPIC"
  resource_name = "dlq-"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = "CREATE"
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_kafka_acl" "connectors_source_write_topic_dlq" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "TOPIC"
  resource_name = "dlq-"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = "WRITE"
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_kafka_acl" "connectors_source_read_topic_dlq" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "TOPIC"
  resource_name = "dlq-"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = "READ"
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}
# Consumer group
resource "confluent_kafka_acl" "connectors_source_consumer_group" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "GROUP"
  resource_name = "connect"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = "READ"
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Credentials / API Keys
# --------------------------------------------------------
resource "confluent_api_key" "connector_key" {
  display_name = "connector-${var.cc_cluster_name}-key-${random_id.id.hex}"
  description  = local.description
  owner {
    id          = confluent_service_account.connectors.id
    api_version = confluent_service_account.connectors.api_version
    kind        = confluent_service_account.connectors.kind
  }
  managed_resource {
    id          = confluent_kafka_cluster.cc_kafka_cluster.id
    api_version = confluent_kafka_cluster.cc_kafka_cluster.api_version
    kind        = confluent_kafka_cluster.cc_kafka_cluster.kind
    environment {
      id = confluent_environment.cc_handson_env.id
    }
  }
  depends_on = [
    confluent_kafka_acl.connectors_source_create_topic_demo,
    confluent_kafka_acl.connectors_source_write_topic_demo,
    confluent_kafka_acl.connectors_source_read_topic_demo,
    confluent_kafka_acl.connectors_source_create_topic_dlq,
    confluent_kafka_acl.connectors_source_write_topic_dlq,
    confluent_kafka_acl.connectors_source_read_topic_dlq,
    confluent_kafka_acl.connectors_source_consumer_group,
  ]
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Create Kafka topics for the Salesforce CDC Connector
# --------------------------------------------------------
resource "confluent_kafka_topic" "salesforce_contacts" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  topic_name    = "salesforce_contacts"
  partitions_count   = 1
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Create schema for the Salesforce CDC Connector topic salesforce_contacts
# --------------------------------------------------------
resource "confluent_schema" "avro-salesforce_contacts" {
  schema_registry_cluster {
    id =confluent_schema_registry_cluster.cc_sr_cluster.id
  }
  rest_endpoint = confluent_schema_registry_cluster.cc_sr_cluster.rest_endpoint
  subject_name = "salesforce_contacts-value"
  format = "AVRO"
  schema = file("./schema/schema-salesforce_contacts-value-v1.avsc")
  credentials {
    key    = confluent_api_key.sr_cluster_key.id
    secret = confluent_api_key.sr_cluster_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Create Kafka topics for the Ice-Breaker
# --------------------------------------------------------
resource "confluent_kafka_topic" "salesforce_mycalls" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  topic_name    = "salesforce_mycalls"
  partitions_count   = 1
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Create schema for the Ice-Breaker topic salesforce_mycalls
# --------------------------------------------------------
resource "confluent_schema" "avro-salesforce_mycalls" {
  schema_registry_cluster {
    id =confluent_schema_registry_cluster.cc_sr_cluster.id
  }
  rest_endpoint = confluent_schema_registry_cluster.cc_sr_cluster.rest_endpoint
  subject_name = "salesforce_mycalls-value"
  format = "AVRO"
  schema = file("./schema/schema-salesforce_mycalls-value-v1.avsc")
  credentials {
    key    = confluent_api_key.sr_cluster_key.id
    secret = confluent_api_key.sr_cluster_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Create Tags
# --------------------------------------------------------
resource "confluent_tag" "pii" {
  schema_registry_cluster {
    id = confluent_schema_registry_cluster.cc_sr_cluster.id
  }
  rest_endpoint = confluent_schema_registry_cluster.cc_sr_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.sr_cluster_key.id
    secret = confluent_api_key.sr_cluster_key.secret
  }

  name = "PII"
  description = "PII tag"

  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_tag" "public" {
  schema_registry_cluster {
    id = confluent_schema_registry_cluster.cc_sr_cluster.id
  }
  rest_endpoint = confluent_schema_registry_cluster.cc_sr_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.sr_cluster_key.id
    secret = confluent_api_key.sr_cluster_key.secret
  }

  name = "Public"
  description = "Public tag"

  lifecycle {
    prevent_destroy = false
  }
}
# --------------------------------------------------------
# Bind Tags to Topics
# --------------------------------------------------------
resource "confluent_tag_binding" "salesforce_contacts" {
  schema_registry_cluster {
    id = confluent_schema_registry_cluster.cc_sr_cluster.id
  }
  rest_endpoint = confluent_schema_registry_cluster.cc_sr_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.sr_cluster_key.id
    secret = confluent_api_key.sr_cluster_key.secret
  }

  tag_name = "PII"
  entity_name = "${confluent_schema_registry_cluster.cc_sr_cluster.id}:${confluent_kafka_cluster.cc_kafka_cluster.id}:${confluent_kafka_topic.salesforce_contacts.topic_name}"
  entity_type = "kafka_topic"

  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Connectors
# --------------------------------------------------------

# Salesforce CDC 
resource "confluent_connector" "salesforcecdc" {
  environment {
    id = confluent_environment.cc_handson_env.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  config_sensitive = {}
  config_nonsensitive = {
    "connector.class"             = "SalesforceCdcSource"
    "name"                        = "SFCDC_leads"
    "kafka.auth.mode"             = "SERVICE_ACCOUNT"
    "kafka.service.account.id"    = confluent_service_account.connectors.id
    "kafka.topic"                 = confluent_kafka_topic.salesforce_contacts.topic_name
    "schema.context.name"         = "default"
    "salesforce.grant.type"       = "PASSWORD"
    "salesforce.instance"         = "https://login.salesforce.com"
    "salesforce.channel.type"     = "SINGLE"
    "salesforce.initial.start"    = "latest"
    "request.max.retries.time.ms" = "30000"
    "connection.max.message.size" = "1048576"
    "output.data.format"          = "AVRO"
    "tasks.max"                   = "1"
    "salesforce.username"         = var.sf_user
    "salesforce.password"         = var.sf_password
    "salesforce.cdc.name"         = var.sf_cdc_name
    "salesforce.password.token"   = var.sf_password_token
    "salesforce.consumer.key"     = var.sf_consumer_key
    "salesforce.consumer.secret"  = var.sf_consumer_secret
  }
  depends_on = [
    confluent_kafka_acl.connectors_source_create_topic_demo,
    confluent_kafka_acl.connectors_source_write_topic_demo,
    confluent_kafka_acl.connectors_source_read_topic_demo,
    confluent_kafka_acl.connectors_source_create_topic_dlq,
    confluent_kafka_acl.connectors_source_write_topic_dlq,
    confluent_kafka_acl.connectors_source_read_topic_dlq,
    confluent_kafka_acl.connectors_source_consumer_group,
  ]
  lifecycle {
    prevent_destroy = false
  }
}


