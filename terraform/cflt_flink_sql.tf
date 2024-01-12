
# --------------------------------------------------------
# Flink SQL: CREATE TABLE salesforce_myleads
# --------------------------------------------------------
resource "confluent_flink_statement" "create_salesforce_myleads" {
  depends_on = [
    resource.confluent_environment.cc_handson_env,
    resource.confluent_schema_registry_cluster.cc_sr_cluster,
    resource.confluent_kafka_cluster.cc_kafka_cluster,
    resource.confluent_connector.salesforcecdc,
    resource.confluent_flink_compute_pool.cc_flink_compute_pool
  ]    
  compute_pool {
    id = confluent_flink_compute_pool.cc_flink_compute_pool.id
  }
  principal {
    id = confluent_service_account.app_manager.id
  }
  statement  = "CREATE TABLE salesforce_myleads(saluation STRING,firstname STRING,lastname STRING,information STRING,email STRING,company STRING) WITH ('kafka.partitions' = '1');"
  properties = {
    "sql.current-catalog"  = confluent_environment.cc_handson_env.display_name
    "sql.current-database" = confluent_kafka_cluster.cc_kafka_cluster.display_name
  }
  rest_endpoint   =  confluent_flink_compute_pool.cc_flink_compute_pool.rest_endpoint
  credentials {
    key    = confluent_api_key.env-manager-flink-api-key.id
    secret = confluent_api_key.env-manager-flink-api-key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Flink SQL: INSERT INTO myleads
# --------------------------------------------------------
resource "confluent_flink_statement" "insert_myleads" {
  depends_on = [
    resource.confluent_environment.cc_handson_env,
    resource.confluent_schema_registry_cluster.cc_sr_cluster,
    resource.confluent_kafka_cluster.cc_kafka_cluster,
    resource.confluent_connector.salesforcecdc,
    resource.confluent_flink_compute_pool.cc_flink_compute_pool,
    resource.confluent_flink_statement.create_salesforce_myleads
  ]    
  compute_pool {
    id = confluent_flink_compute_pool.cc_flink_compute_pool.id
  }
  principal {
    id = confluent_service_account.app_manager.id
  }
  statement  = "INSERT into salesforce_myleads SELECT Salutation, FirstName, LastName, concat(FirstName,' ',LastName,' ', Company) as information, Email, Company FROM salesforce_contacts;"
  properties = {
    "sql.current-catalog"  = confluent_environment.cc_handson_env.display_name
    "sql.current-database" = confluent_kafka_cluster.cc_kafka_cluster.display_name
  }
  rest_endpoint   =  confluent_flink_compute_pool.cc_flink_compute_pool.rest_endpoint
  credentials {
    key    = confluent_api_key.env-manager-flink-api-key.id
    secret = confluent_api_key.env-manager-flink-api-key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}