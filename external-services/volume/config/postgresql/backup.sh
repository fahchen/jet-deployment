#!/usr/bin/env bash

set -e

NOW=$(date '+%Y%m%d-%H%M%S')

pg_dump -U $POSTGRES_USER -Ft -d airbase_prod -f ./$NOW-db.tar
pg_dump -U $POSTGRES_USER -Ft -d eventstore_prod -f ./$NOW-es.tar

# remove-files option not supported
tar caf $NOW.tar.gz $NOW-db.tar $NOW-es.tar
rm $NOW-db.tar $NOW-es.tar
