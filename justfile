set dotenv-load := true

default:
    @just --list

echo:
    echo $DATABASE_URL

dev: 
    mprocs "just db_start" "just watch_dev_server" "just watch_test" "just watch_sql_files"

watch_dev_server:
    watchexec --restart --verbose --clear --wrap-process=session --stop-signal SIGTERM --exts gleam --watch ./ -- "gleam run"

watch_test:
    watchexec --restart --verbose --clear --wrap-process=session --stop-signal SIGTERM --exts gleam --watch ./ -- "gleam test"

# DATABASE
#######################

# Generate queries using squirrel
db_generate_queries: 
    gleam run -m squirrel

# Watch /.*sql and generate queries using squirrel
watch_sql_files:
    watchexec --restart --verbose --clear --wrap-process=session --stop-signal SIGTERM --exts sql --watch ./ -- "just db_generate_queries"

# Dbmate
db *ARGS: 
    dbmate {{ARGS}}

# Start dev database
db_start:
    cd ./db/dev/ && ./run-postgres.sh

# Start psql session for dev database
db_inspect:
    psql $DATABASE_URL
    # docker exec -it $NAME psql -h localhost -U postgres

