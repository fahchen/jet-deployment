#!/bin/bash

set -ex

# postgresql 所在 namespace
POSTGRESQL_NAMESPACE=postgresql

# postgresql 示例名称
POSTGRESQL_INSTANCE=postgresql

# minio 数据与备份位置
MINIO_DATA_DIR=/opt/apps/data/
MINIO_BACKUP_DIR=/opt/backup/minio

# 复制到备份服务器IP，为空则
REMOTE_SERVER_IP=10.0.0.1
REMOTE_SERVER_PORT=22
REMOTE_BACKUP_DIR=/opt/remote-backup

# 保留备份期限，单位：天
EXPIR_EDAY=30

# 获得日期字符串
GetDateStr () {
  echo `date +%Y%m%d`
}

# 备份 postgresql 数据
PostgresqlDump () {
  TTL=$(($EXPIR_EDAY*24))
  velero create schedule postgres \
    --schedule "0 2 * * *" \
    --ttl $TTL \
    --volume-snapshot-locations volume-snapshot \
    --storage-location backup \
    --include-namespaces $POSTGRESQL_NAMESPACE \
    --selector app.kubernetes.io/instance=$POSTGRESQL_INSTANCE \
    --snapshot-volumes \
    --default-volumes-to-fs-backup
}

# 备份 minio 数据
MinioBackup () {
  [ ! -d "$MINIO_BACKUP_DIR" ] && mkdir -p $MINIO_BACKUP_DIR || echo "已存在$MINIO_BACKUP_DIR"
  BackupFileName=$(GetDateStr)-minio.tar.gz
  tar cf $MINIO_BACKUP_DIR/$BackupFileName $MINIO_DATA_DIR
  if [ "$REMOTE_SERVER_IP" != '' ]; then
    echo "将新备份文件跨服务器备份到 $REMOTE_SERVER_IP ****"
    scp -P$REMOTE_SERVER_PORT $MINIO_BACKUP_DIR/$_BackupFileName $REMOTE_SERVER_IP:$REMOTE_BACKUP_DIR/minio/
  fi
}

# 查看数据库备份
ListPostgresqlDump() {
  velero get backup
}

# 检查数据库备份是否成功
CheckPostgresqlBackup() {
  STATUS=$(kubectl get -n velero backup -o jsonpath='{.items[-1:].status.phase}')
  BACKUP_NAME=$(kubectl get -n velero backup -o jsonpath='{.items[-1:].metadata.name}')
  case $STATUS in
    "Completed")
      echo "备份成功，备份名 $BACKUP_NAME. 运行\"velero backup describe $BACKUP_NAME --details\" 查看更多信息"
      ;;
    *)
      INFORMATION_SUMMARY="$(kubectl get -n velero backup -o jsonpath='{range .items[-1:]}{.metadata.name}{"\t"}{.status.startTimestamp}{"\t"}{.status.completionTimestamp}{"\t"}{.status.phase}{end}')"
      echo -e "备份失败! 运行\"velero backup describe $BACKUP_NAME --details\" 查看更多信息"
      echo  "备份基础信息：$INFORMATION_SUMMARY"
      ;;
  esac
}

# 清除过期备份
ClearExpiredBackup () {
  find $MINIO_BACKUP_DIR -maxdepth 1 -type f -mtime +$EXPIR_EDAY -name "*.tar.gz" | xargs rm -rf
  ssh -p$REMOTE_SERVER_PORT $REMOTE_SERVER_IP "find $REMOTE_BACKUP_DIR/minio/ -maxdepth 1 -type f -mtime +$EXPIR_EDAY -name '*.tar.gz' -exec  rm -rf {} \;"
}
