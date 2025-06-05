
output "kafka_broker_url" {
  description = "Bootstrap server for Kafka (host)"
  value       = "localhost:29092"
}

output "schema_registry_url" {
  description = "Schema Registry HTTP endpoint"
  value       = "http://localhost:8081"
}
