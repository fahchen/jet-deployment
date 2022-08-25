# krunvm

## Database
```bash
# Create the db MicroVM
krunvm create -p 5432:5432 --name airbase-db postgres:13.7-alpine

# Enter the vm
krunvm start airbase-db sh

# In the vm, initialize the db
POSTGRES_PASSWORD=postgres docker-entrypoint.sh postgres

# Exit the vm, and start the vm again
krunvm start airbase-db
```

## Minio
```bash
# Create the minio MicroVM
krunvm create -p 9000:9000 -p 9001:9001 --name airbase-minio minio/minio

# Start the vm
krunvm start airbase-minio "minio server /data --console-address \":9001\""
```
