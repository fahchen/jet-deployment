### External services for jet (docker-compose)

#### Start services
```bash
make up
```

#### Installation
1. Prepare config files

```bash
cp volume/config/redis/redis.sample.conf volume/config/redis/redis.conf
cp volume/config/postgresql/postgresql.conf.sample volume/config/postgresql/postgresql.conf
cp volume/config/minio/redis/redis.sample.conf volume/config/minio/redis/redis.conf
```

2. setup the local env file
```bash
touch external-services.local.env
```

```env
# external-services.local.env
REDIS_CONFIG_PATH="/usr/local/etc/redis/redis.conf"
POSTGRES_CONFIG_PATH="/usr/local/etc/postgresql/postgresql.conf"
MINIO_REDIS_CONFIG_PATH="/usr/local/etc/redis/redis.conf"
```

3. Start services
```bash
docker-compose -f docker-compose.yaml -f redis.yaml -f sonic.yaml -f postgresql.yaml -f minio.yaml up -d
```

#### Misc

1. Init minio
```bash
docker-compose -f docker-compose.yaml -f minio_init.yaml run minio_init
```

3. upload image to trigger event
```bash
mc cp /path/to/image.jpg minio/jet-public/image.jpg --attr "Versions=thumbnail;Purpose=project_attachment"
```
