# 使用说明

## 概述

该脚本用于备份数据库和Minio数据，并提供一些相关功能，例如查看数据库备份和清除过期备份。

## 配置参数

在运行脚本之前，您需要配置以下参数：

- `POSTGRESQL_NAMESPACE`：Postgresql 所在 k8s namespace。
- `POSTGRESQL_INSTANCE`：Postgresql 在 k8s 中的实例名
- `MINIO_DATA_DIR`：Minio数据的目录路径。
- `MINIO_BACKUP_DIR`：Minio备份文件的目录路径。
- `REMOTE_SERVER_IP`：备份服务器的IP地址（可选）。如果要进行跨服务器备份，请提供远程服务器的IP地址。
- `REMOTE_SERVER_PORT`：备份服务器的SSH端口号（可选）。默认为22。
- `REMOTE_BACKUP_DIR`：远程备份服务器的目录路径（可选）。如果启用了远程备份，请提供远程备份目录的路径。
- `EXPIR_EDAY`：备份文件保留期限（以天为单位）。

## 脚本功能

以下是脚本提供的主要功能和对应的命令示例：

### 备份数据库

使用`PostgresqlDump`函数可以创建定期备份数据库的计划任务。

示例：

```bash
PostgresqlDump
```

### 备份Minio数据

使用`MinioBackup`函数可以备份Minio数据。

示例：

```bash
MinioBackup
```

### 查看数据库备份

使用`ListPostgresqlDump`函数可以列出数据库备份。

示例：

```bash
ListPostgresqlDump
```

### 检查数据库备份状态

使用`CheckPostgresqlBackup`函数可以检查最近一次数据库备份的状态。

示例：

```bash
CheckPostgresqlBackup
```

### 清除过期备份

使用`ClearExpiredBackup`函数可以清除过期的备份文件。

示例：

```bash
ClearExpiredBackup
```

## 注意事项

- 在运行脚本之前，请确保已正确配置脚本中的参数。
- 如果要进行跨服务器备份，确保在本地和远程服务器之间已建立可靠的SSH连接。
- 运行脚本时，建议先进行测试和验证，以确保功能正常工作。
- 请根据实际情况调整备份计划和保留期限。
