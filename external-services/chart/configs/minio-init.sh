#!/usr/bin/env sh
set -eux -o pipefail

mc config host add minio $MINIO_SERVER minio minio123

setup_event() {
  mc event add minio/$1 arn:minio:sqs::_:redis --event put --suffix $2 --ignore-existing
}

setup_bucket() {
  mc mb minio/$1 --ignore-existing

  setup_event $1 .jpg
  setup_event $1 .JPG
  setup_event $1 .jpeg
  setup_event $1 .JPEG
  setup_event $1 .png
  setup_event $1 .PNG
}

setup_bucket minio-public
setup_bucket minio-private

mc policy set download minio/minio-public
mc admin service restart minio
