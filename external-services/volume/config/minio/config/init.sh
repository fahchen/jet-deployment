#!/usr/bin/env sh

apk add gettext --quiet

mc config host add minio http://minio:9090 $MINIO_ACCESS_KEY $MINIO_SECRET_KEY

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

setup_bucket $MINIO_PRIVATE_BUCKET
setup_bucket $MINIO_PUBLIC_BUCKET

mc policy set download minio/$MINIO_PUBLIC_BUCKET
mc admin service restart minio
