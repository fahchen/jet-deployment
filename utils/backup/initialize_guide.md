# 备份系统

## 1. 初始化

- ### 1.1. 运行环境

  - Kubernetes 集群环境

- ### 1.2. 依赖应用

  - helm
  - velero
  - minio

- ### 1.3. 应用部署

  - #### `helm` [安装脚本](https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3)

    ```bash
    $ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    $ chmod 700 get_helm.sh
    $ ./get_helm.sh
    ```

  - #### `velero` [参数配置说明](https://github.com/vmware-tanzu/helm-charts/blob/main/charts/velero/README.md)

    ```bash
    $ helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts
    $ helm upgrade --install -n velero --create-namespace velero vmware-tanzu/velero -f velero.yaml
    ```

    > `velero` [二进制文件下载](https://github.com/vmware-tanzu/velero/releases/tag/v1.11.0) 

  - #### `minio` [参数配置说明](https://github.com/bitnami/charts/blob/main/bitnami/minio/README.md)

    ```bash
    $ helm repo add bitnami https://charts.bitnami.com/bitnami
    $ helm upgrade --install -n minio --create-namespace minio bitnami/minio -f minio.yaml
    ```
