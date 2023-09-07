# External services

## Add bitnami helm charts

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

## Install postgresql

```bash
helm install postgresql bitnami/postgresql -f postgresql.yaml --version 12.5.7
```

> Postgresql chart version is 12.5.7

### Install minio

```bash
helm install minio bitnami/minio -f minio.yaml --version 12.6.4
```

> Minio chart version is 12.6.4