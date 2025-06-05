terraform {
  required_version = ">= 1.4.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "tcp://localhost:2375"
}

############################################
# Network
############################################
resource "docker_network" "kafka_net" {
  name = "kafka_network"
}

############################################
# ZooKeeper (single node for local dev)
############################################
resource "docker_image" "zookeeper" {
  name = "bitnami/zookeeper:${var.zookeeper_version}"
}

resource "docker_container" "zookeeper" {
  name  = "zookeeper"
  image = docker_image.zookeeper.name
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.kafka_net.name
  }

  env = [
    "ALLOW_ANONYMOUS_LOGIN=yes"
  ]

  ports {
    internal = 2181
    external = 2181
  }
}

############################################
# Kafka Broker (single broker for local dev)
############################################
resource "docker_image" "kafka" {
  name = "bitnami/kafka:${var.kafka_version}"
}

resource "docker_container" "kafka" {
  name  = "kafka"
  image = docker_image.kafka.name
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.kafka_net.name
  }

  depends_on = [docker_container.zookeeper]

  env = [
    "KAFKA_BROKER_ID=1",
    "KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181",
    "KAFKA_CFG_LISTENERS=PLAINTEXT://:9092,PLAINTEXT_HOST://0.0.0.0:29092",
    "KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092,PLAINTEXT_HOST://localhost:29092",
    "KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT",
    "KAFKA_CFG_INTER_BROKER_LISTENER_NAME=PLAINTEXT",
    "KAFKA_CFG_AUTO_CREATE_TOPICS_ENABLE=true",
    "ALLOW_PLAINTEXT_LISTENER=yes"
  ]

  ports {
    internal = 9092
    external = 9092
  }

  ports {
    internal = 29092
    external = 29092
  }
}

############################################
# Confluent Schema Registry
############################################
resource "docker_image" "schema_registry" {
  name = "confluentinc/cp-schema-registry:${var.schema_registry_version}"
}

resource "docker_container" "schema_registry" {
  name  = "schema_registry"
  image = docker_image.schema_registry.name
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.kafka_net.name
  }

  depends_on = [docker_container.kafka]

  env = [
    "SCHEMA_REGISTRY_HOST_NAME=schema_registry",
    "SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS=PLAINTEXT://kafka:9092",
    "SCHEMA_REGISTRY_LISTENERS=http://0.0.0.0:8081"
  ]

  ports {
    internal = 8081
    external = 8081
  }
}
