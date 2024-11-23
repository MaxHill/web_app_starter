set dotenv-load := true

default:
    @just --list

echo:
    echo $TEMPLATE_DATABASE_URL

dev: 
    mprocs "just db_start" "just watch_dev_server" "just watch_test" "just watch_sql_files"

watch_dev_server:
    watchexec --restart --verbose --clear --wrap-process=session --stop-signal SIGTERM --exts gleam --watch ./src -- "gleam run"

watch_test:
    @just db wait
    @just db -e "TEST_DATABASE_URL" drop
    @just db -e "TEST_DATABASE_URL" up
    watchexec --restart --verbose --clear --wrap-process=session --stop-signal SIGTERM --exts gleam --watch ./ -- "gleam test"

# DATABASE
#######################

# Generate queries using squirrel
db_generate_queries: 
    gleam run -m squirrel

# Watch /.*sql and generate queries using squirrel
watch_sql_files:
    watchexec --restart --verbose --clear --wrap-process=session --stop-signal SIGTERM --exts sql --watch ./src/models -- "just db_generate_queries"

# Dbmate
db *ARGS: 
    dbmate {{ARGS}}

# Start dev database
db_start:
    cd ./db/dev/ && ./run-postgres.sh

# Start psql session for dev database
db_inspect *ARGS:
    psql $DATABASE_URL {{ARGS}}
    # docker exec -it $NAME psql -h localhost -U postgres

db_inspect_test *ARGS:
    psql $TEST_DATABASE_URL {{ARGS}}

db_inspect_template *ARGS:
    psql $TEMPLATE_DATABASE_URL {{ARGS}}

# Remove database data
db_delete:
    rm -rf ./db/dev/pgdata/*

db_schema: 
    psql $TEST_DATABASE_URL -f "./db/schema.sql"
