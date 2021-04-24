## Usage

### Prerequisites
- Helm v3 [installed](https://helm.sh/docs/using_helm/#installing-helm)
- install `traefik`

```bash
helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik
````

### create imagePullSecrets
```bash
kubectl create secret docker-registry jethangzhouregistry \
          --docker-server=$DOCKER_REGISTRY \
          --docker-username=$DOCKER_USERNAME \
          --docker-password=$DOCKER_PASSWORD
```

### Prepare config file
```bash
touch values.local.yaml
```

```yaml
# values.local.yaml

airbase:
  image:
    registry: registry.cn-hangzhou.aliyuncs.com
    repository: jet/airbase_umbrella
    tag: "release"
    imagePullSecrets:
      # the secret created above
      - name: jetregistry
    pullPolicy: IfNotPresent

aircrew:
  image:
    registry: registry.ap-northeast-1.aliyuncs.com
    airbaseRepository: jet/aircrew
    tag: "release"
    imagePullSecrets:
      # the secret created above
      - name: jetregistry
    pullPolicy: IfNotPresent
```

```yaml
# values.local.yaml

# [Jet]
jetHost: supervision.jet.localhost

# [Minio]
minioHost: supervision.jet.localhost
```

```yaml
# values.local.yaml

# Set IPs properly

# [PostgreSQL]
postgresqlIP: 10.0.0.18

# [Redis]
redisIP: 10.0.0.18

# [Minio]
minioServiceIP: 10.0.0.18
minioredisIP: 10.0.0.18

# [Sonic]
sonicGenericIP: 10.0.0.18
sonicUsersNamesIP: 10.0.0.18
```

```yaml
# values.local.yaml

# setup scixir
scixir:
  minioRedisUrl: redis://{{ release-name }}-jet-chart-minioredis:6379/0
  minioHost: {{ release-name }}-jet-chart-minio
```

## Commands
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
```
