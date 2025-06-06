# To override the default bash path (e.g. on Linux/Mac), run:
# terraform apply -var="bash_path=/bin/bash"

variable "bash_path" {
  description = "Path to Bash executable. Customize for your OS."
  type        = string
  default     = "C:/Program Files/Git/bin/bash.exe"
}

resource "null_resource" "create_kafka_topics" {
  depends_on = [docker_container.kafka]

  provisioner "local-exec" {
    interpreter = [var.bash_path, "-c"]

    command = <<EOT
      docker exec kafka kafka-topics.sh --create --if-not-exists --topic account-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1;
      docker exec kafka kafka-topics.sh --create --if-not-exists --topic customer-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1;
      docker exec kafka kafka-topics.sh --create --if-not-exists --topic transaction-requests --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1;
      docker exec kafka kafka-topics.sh --create --if-not-exists --topic transaction-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1;
      docker exec kafka kafka-topics.sh --create --if-not-exists --topic balance-update-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1;
      docker exec kafka kafka-topics.sh --create --if-not-exists --topic fraud-detection-events --bootstrap-server localhost:9092 --partitions 2 --replication-factor 1;
      docker exec kafka kafka-topics.sh --create --if-not-exists --topic transaction-hold-commands --bootstrap-server localhost:9092 --partitions 2 --replication-factor 1;
      docker exec kafka kafka-topics.sh --create --if-not-exists --topic account-commands --bootstrap-server localhost:9092 --partitions 2 --replication-factor 1;
      docker exec kafka kafka-topics.sh --create --if-not-exists --topic transfer-saga-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
	  docker exec kafka kafka-topics.sh --create --if-not-exists --topic logs --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1;
	  docker exec kafka kafka-topics.sh --create --if-not-exists --topic api-gateway-requests --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1;
	  docker exec kafka kafka-topics.sh --create --if-not-exists --topic api-gateway-responses --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1;

    EOT
  }
}
