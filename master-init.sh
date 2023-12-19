#!/bin/bash
set -e

# Create the replication user
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE ROLE replica WITH REPLICATION LOGIN PASSWORD 'replicapassword';
EOSQL

# Configure PostgreSQL for replication
# These commands append the configuration to the files.
# Note that these changes will take effect when the PostgreSQL server is (re)started.
echo "host replication replica all md5" >> "$PGDATA/pg_hba.conf"
echo "wal_level = replica" >> "$PGDATA/postgresql.conf"
echo "max_wal_senders = 3" >> "$PGDATA/postgresql.conf"
echo "wal_keep_size = 64" >> "$PGDATA/postgresql.conf"
