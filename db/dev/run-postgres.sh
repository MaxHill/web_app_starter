echo "DB: ${DB_NAME} TEST_DB: ${DB_TEST_NAME}"
echo "-- This file is generated by run-postgres.sh. Do not change.\nCREATE DATABASE \"${DB_NAME}\";\n CREATE DATABASE \"${DB_TEST_NAME}\";" > `pwd`/init-multiple-dbs.sql

docker run --rm --name $DB_CONTAINER_NAME \
  --volume `pwd`/pgdata:/var/lib/pgsql/data \
  --volume `pwd`/mnt_data:/mnt/data \
  --volume `pwd`/pg_hba.conf:/etc/postgresql/pg_hba.conf \
  --volume `pwd`/postgresql.conf:/etc/postgresql/postgresql.conf \
  --volume `pwd`/init-multiple-dbs.sql:/docker-entrypoint-initdb.d/init-multiple-dbs.sql \
  --volume `pwd`/../schema.sql:/schema.sql \
  -e POSTGRES_PASSWORD=password \
  -e POSTGRES_USER=postgres \
  -e PGDATA=/var/lib/pgsql/data/pgdata14 \
  -e POSTGRES_INITDB_ARGS="--data-checksums --encoding=UTF8" \
  -p ${DB_HOST_PORT}:5432 \
  ${DB_DOCKER_REPO}:${DB_VERSION_TAG} \
  postgres \
    -c 'config_file=/etc/postgresql/postgresql.conf' \
    -c 'hba_file=/etc/postgresql/pg_hba.conf'
