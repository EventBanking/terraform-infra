
# Event Banking – Local Kafka Cluster with Terraform + Docker

This Terraform project spins up a **single‑broker Kafka cluster**, ZooKeeper, and the Confluent Schema Registry in Docker.  

The following topics are also created:
- account-events 
- customer-events 
- transaction-requests 
- transaction-events 
- balance-update-events 
- fraud-detection-events 
- transaction-hold-commands 
- account-commands 
- transfer-saga-events 

---

## Quick start

```bash
terraform init      # download docker provider
terraform apply     # type “yes” when prompted
```

After a minute you’ll have:

| Service            | URL / address                      |
|--------------------|------------------------------------|
| Kafka broker       | `localhost:29092` (plaintext)      |
| ZooKeeper          | `localhost:2181`                   |
| Schema Registry    | `http://localhost:8081`            |

> **Tip:** The broker also listens on the Docker network as `kafka:9092`, which is the hostname other containers should use.

---

## Customisation

Edit `variables.tf` or supply values on the CLI, e.g.

```bash
terraform apply -var="kafka_version=3.6"
```

---

## Destroying

```bash
terraform destroy
```

---