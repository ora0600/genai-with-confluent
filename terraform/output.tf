
output "A01_cc_genai_env" {
  description = "Confluent Cloud Environment ID"
  value       = resource.confluent_environment.cc_handson_env.id
}

output "A02_cc_genai_sr" {
  description = "CC Schema Registry Region"
  value       = data.confluent_schema_registry_region.cc_handson_sr
}

output "A03_cc_sr_cluster" {
  description = "CC SR Cluster ID"
  value       = resource.confluent_schema_registry_cluster.cc_sr_cluster.id
}

output "A04_cc_sr_cluster_endpoint" {
  description = "CC SR Cluster ID"
  value       = resource.confluent_schema_registry_cluster.cc_sr_cluster.rest_endpoint
}

output "A05_cc_kafka_cluster" {
  description = "CC Kafka Cluster ID"
  value       = resource.confluent_kafka_cluster.cc_kafka_cluster.id
}

output "A06_cc_kafka_cluster_bootsrap" {
  description = "CC Kafka Cluster ID"
  value       = resource.confluent_kafka_cluster.cc_kafka_cluster.bootstrap_endpoint

}

output "B01_cc_compute_pool_name" {
  value = confluent_flink_compute_pool.cc_flink_compute_pool.id
}

output "C_01_salesforcecdc" {
  description = "SalesForce CDC Connector ID"
  value       = resource.confluent_connector.salesforcecdc.id
}

output "D_01_SRKey" {
  description = "CC SR Key"
  value       = confluent_api_key.sr_cluster_key.id
}
output "D_02_SRSecret" {
  description = "CC SR Secret"
  value       = confluent_api_key.sr_cluster_key.secret
  sensitive = true
}

output "D_03_AppManagerKey" {
  description = "CC AppManager Key"
  value       = confluent_api_key.app_manager_kafka_cluster_key.id
}

output "D_04_AppManagerSecret" {
  description = "CC AppManager Secret"
  value       = confluent_api_key.app_manager_kafka_cluster_key.secret
  sensitive = true
}

output "D_05_ClientKey" {
  description = "CC clients Key"
  value       = confluent_api_key.clients_kafka_cluster_key.id
}
output "D_06_ClientSecret" {
  description = "CC Client Secret"
  value       = confluent_api_key.clients_kafka_cluster_key.secret
  sensitive = true
}

output "E01_BlockStart" {
  value = "***********************************************************************************************************"
}

output "E02_NewLeads" {
  value = "Login into your Salesforce Account and Enter new Leads: https://confluent-ad-dev-ed.develop.my.salesforce.com"
}

output "E03_StartGenAI" {
  value = "Then start genAI App: python3 ice_breaker.py -f client.properties -from salesforce_myleads -to salesforce_mycalls"
}  

output "E04_BlockEnd" {
  value = "***********************************************************************************************************"
}
