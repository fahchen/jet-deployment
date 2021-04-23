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
kubectl create secret docker-registry jetregistry \
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

scixir:
  minioRedisUrl: redis://release-jet-chart-minioredis:6379/0
  minioHost: release-jet-chart-minio
```

## Commands
```bash
# install with name of `workflow`
make install RELEASE=workflow
```

## HowTo

### Setup TLS
```bash
# create secrets
kubectl create secret tls minio-tls-secret \
  --cert=oss.workflow.jet.work.pem \
  --key=oss.workflow.jet.work.key

kubectl create secret tls jet-tls-secret \
  --cert=workflow.jet.work.pem \
  --key=workflow.jet.work.key
```
```yaml
# set values in `values.local.yaml`
jetTLSSecret: jet-tls-secret
minioTLSSecret: minio-tls-secret
```
