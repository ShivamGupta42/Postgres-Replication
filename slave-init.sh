#!/bin/bash
set -e

echo "Starting slave initialization..."

# Function to wait for PostgreSQL to start on the master
wait_for_postgres() {
  until pg_isready -h pg-master -U postgres; do
    echo "Waiting for master to be ready..."
    sleep 2
  done
}

# Wait for the master to be fully set up
wait_for_postgres

echo "Master is ready, proceeding with slave setup..."

# Stop PostgreSQL service if running (it shouldn't be at this point)
# This is a precautionary measure.
pg_ctl -D "$PGDATA" -m fast -w stop || true

echo "PostgreSQL service stopped, cleaning up data directory..."

# Clean up any existing data
rm -rf "$PGDATA"/*

echo "Performing base backup..."

# Perform base backup
PGPASSWORD=replicapassword pg_basebackup -h pg-master -D "$PGDATA" -U replica -X stream -P -v

echo "Base backup completed, configuring standby mode..."

# Create an empty standby.signal file to start the server in standby mode
touch "$PGDATA/standby.signal"

# Set up primary connection information for the standby server

echo "Creating primary_conninfo file..."
echo "primary_conninfo = 'host=pg-master port=5432 user=replica password=replicapassword'" > "$PGDATA/primary_conninfo"

echo "Including primary_conninfo in postgresql.conf..."
echo "include = 'primary_conninfo'" >> "$PGDATA/postgresql.conf"

echo "Slave setup complete."
