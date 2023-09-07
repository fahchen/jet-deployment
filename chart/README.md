## Usage

### Prerequisites
- Helm v3 [installed](https://helm.sh/docs/using_helm/#installing-helm)
- install `traefik`

```bash
helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik
````

### Prepare config file
```bash
touch values.local.yaml
```

1. set imageCredentials for image pulling
```yaml
# values.local.yaml
imageCredentials:
  registry: registry.cn-hangzhou.aliyuncs.com
  username: deploy-man@skylark
  password: changeit
```

2. set image info for image pulling
```yaml
# values.local.yaml

airbase:
  image:
    repository: jet/airbase_umbrella
    tag: "release"
    pullPolicy: IfNotPresent
```

3. set host for jet and minio
```yaml
# values.local.yaml

# [Jet]
jetHost: supervision.jet.localhost

# [Minio]
minioHost: supervision.jet.localhost
```

4. set IPs for external services
```yaml
# values.local.yaml

# Set IPs properly

# [PostgreSQL]
postgresqlIP: 10.0.0.18

# [Minio]
minioServiceIP: 10.0.0.18
```

## Commands
```bash
# set `RELEASE` in `.env` file

# .env
RELEASE=workflow

# install
make install
```

OR

```bash
# install with name of `workflow`
make install RELEASE=workflow
```

## HowTo

### Setup TLS
```yaml
# values.local.yaml

# [Jet]
jetTLSSecret:
  certificate: base64 encoded certificate-file
  key: base64 encoded key-file

# [Minio]
minioTLSSecret:
  certificate: base64 encoded certificate-file
  key: base64 encoded key-file
minioScheme: https://
minioPort: 443
```

### Subpath support
```yaml
# values.local.yaml

# [Jet]
jetSubpath: /jet
```

### Setup backup
```yaml
# values.local.yaml

# Use velero to back up database
backup:
  # Set the automatic backup for database. The format is 'minute, hour, day, month, week'.
  veleroSchedule: "0 1 * * *"
  # Set the namespaces that need to be backed up.
  includeNamespaces:
    - production
    - database
    - ...
  # Specify the labels of the applications that need to be backed up.
  selector:
    app.kubernetes.io/instance: postgresql
  # [Optional parameter] Specify the storage location for the backup.
  storageLocation: backup
  # Set the time-to-live (TTL) for the backup.
  ttl: "720h0m0s"
  # Set the automatic backup for minio. The format is 'minute, hour, day, month, week'.
  minioSchedule: "0 3 * * *"
  # Store the Minio data in a Persistent Volume Claim (PVC).
  minioDataPVC: "minio-data"
  # Store the Minio backups in a Persistent Volume Claim (PVC).
  minioBackupPVC: "minio-backup"
  # Specify the directory name of the Minio that needs to be backed up.
  minioDataDir: "*"
  # Set the expiration time for the Minio backups.
  minioExpireDay: "30"
```

### backup operation guide
- Create a backup from schedule
```bash
velero create backup $backup_name --from-schedule $schedule_name
```
- List backup
```bash
velero get backup
```
- View a backup detail
```bash
velero describe backups $backup_name --details
```
> $backup_name and $schedule_name fill in as actual
