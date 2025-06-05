
variable "kafka_version" {
  description = "Kafka image tag version"
  type        = string
  default     = "3.7"
}

variable "zookeeper_version" {
  description = "Zookeeper image tag version"
  type        = string
  default     = "3.9"
}

variable "schema_registry_version" {
  description = "Confluent Schema Registry image tag version"
  type        = string
  default     = "7.5.2"
}
