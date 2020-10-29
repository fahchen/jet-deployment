## Usage

#### create imagePullSecrets
```bash
kubectl create secret docker-registry jetregistry \
          --docker-server=$DOCKER_REGISTRY \
          --docker-username=$DOCKER_USERNAME \
          --docker-password=$DOCKER_PASSWORD
```

#### Prepare config file
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

traefik:
  service:
    externalIPs:
      # in a vpc
      - 10.0.0.18
  ports:
    web:
      # redirect http to https
      redirectTo: websecure
```
