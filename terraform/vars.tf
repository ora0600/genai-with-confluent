locals {
  description = "Resource created using terraform"
}

# --------------------------------------------------------
# This 'random_id_4' will make whatever you create (names, etc)
# unique in your account.
# --------------------------------------------------------
resource "random_id" "id" {
  byte_length = 2
}

# ----------------------------------------
# Confluent Cloud Kafka cluster variables
# ----------------------------------------
variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "cc_cloud_provider" {
  type    = string
  default = "AWS"
}

variable "cc_cloud_region" {
  type    = string
  default = "eu-central-1"
}

variable "cc_env_name" {
  type    = string
  default = "cm-genAI"
}

variable "cc_cluster_name" {
  type    = string
  default = "cc_genai_cluster"
}

variable "cc_availability" {
  type    = string
  default = "SINGLE_ZONE"
}

# ------------------------------------------
# Confluent Cloud Schema Registry variables
# ------------------------------------------
variable "sr_cloud_provider" {
  type    = string
  default = "AWS"
}

variable "sr_cloud_region" {
  type    = string
  default = "eu-central-1"
}

variable "sr_package" {
  type    = string
  default = "ESSENTIALS"
}

# --------------------------------------------
# Confluent Cloud Flink Compute Pool variables
# --------------------------------------------
variable "cc_dislay_name" {
  type    = string
  default = "cmgenai_compute_pool"
}

variable "cc_compute_pool_name" {
  type    = string
  default = "cmgenai_flink"
}

variable "cc_compute_pool_cfu" {
  type    = number
  default = 5
}

variable "cc_compute_pool_region" {
  type    = string
  default = "aws.eu-central-1"
}

variable "sf_user" {
  type    = string
  default = "Email Adresse"
}

variable "sf_password" {
  type    = string
  default = "Password "
}

variable "sf_cdc_name" {
  type    = string
  default = "<Object>ChangeEvent"
}

variable "sf_password_token" {
  type    = string
  default = "password token of user"
}

variable "sf_consumer_key" {
  type    = string
  default = "consumer key of connected app"
}

variable "sf_consumer_secret" {
  type    = string
  default = "consumer secret of connected app"
}
