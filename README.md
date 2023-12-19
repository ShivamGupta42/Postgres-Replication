# PostgreSQL Master-Slave Replication Setup

PostgreSQL Master-Slave Replication Setup is a Docker-based configuration for setting up a PostgreSQL replication environment with one master and one slave instance. It's designed for development and testing purposes, providing a hands-on experience with PostgreSQL replication.

## Directory Structure

The project includes the following files:

- `docker-compose.yml` - Docker Compose file to define the master and slave PostgreSQL services.
- `master-init.sh` - Initialization script for setting up the PostgreSQL master instance.
- `slave-init.sh` - Initialization script for setting up the PostgreSQL slave instance.

## Setup

### Prerequisites

Ensure you have Docker and Docker Compose installed on your machine. This setup also requires basic knowledge of PostgreSQL and Docker.

### Starting the Replication Environment

To start the master and slave PostgreSQL instances:

```bash
docker-compose up -d
```

## Connecting to PostgreSQL Instances

After starting the services, you can connect to the master instance to create or modify data, and then connect to the slave instance to verify that the changes are replicated.

**Master Database:**

- **Host:** `localhost` (or Docker machine IP if using Docker Machine)
- **Port:** As defined in `docker-compose.yml` (default: 5432)
- **Username & Password:** As defined in `master-init.sh`

**Slave Database:**

- **Host:** `localhost` (or Docker machine IP if using Docker Machine)
- **Port:** As defined in `docker-compose.yml` (default: 5433)
- **Username & Password:** As defined in `slave-init.sh`

## Scripts Explained

### `master-init.sh`

This script initializes the master database by creating the necessary roles and configurations for replication.

### `slave-init.sh`

This script prepares the slave database by performing a base backup from the master and configuring replication settings.
