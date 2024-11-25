set dotenv-load := true

# List available commands
default:
    @just --list

# Start and start watching everything that's needed to run
dev: 
    mprocs "just db_start" "just watch_dev_server" "just watch_test" "just watch_db_generate_queries"

# Start the dev server with watch 
watch_dev_server:
    @just db wait
    @just db up
    watchexec --restart --verbose --clear --wrap-process=session --stop-signal SIGTERM --exts gleam --watch ./src -- "gleam run"


# Testing
#######################

# Runs tests once (make sure db is running `$ just db_start`)
test:
    @just db wait
    @just db -e "TEST_DATABASE_URL" drop
    @just db -e "TEST_DATABASE_URL" up
    gleam test

# Watch for changes in any gleam file and run tests (make sure db is running `$ just db_start`)
watch_test:
    @just db wait
    @just db -e "TEST_DATABASE_URL" drop
    @just db -e "TEST_DATABASE_URL" up
    watchexec --restart --verbose --clear --wrap-process=session --stop-signal SIGTERM --exts gleam --watch ./ -- "gleam test"

# DATABASE
#######################

# Generate queries using squirrel (make sure db is running `$ just db_start`)
db_generate_queries: 
    gleam run -m squirrel

# Watch ./src/.*sql files and generate queries using squirrel
watch_db_generate_queries:
    @just db wait
    watchexec --restart --verbose --clear --wrap-process=session --stop-signal SIGTERM --exts sql --watch ./src/models -- "just db_generate_queries"

# Alias for dbmate
db *ARGS: 
    dbmate {{ARGS}}

# Start dev database
db_start:
    cd ./db/dev/ && ./run-postgres.sh

# Start psql command for dev database
db_psql *ARGS:
    psql $DATABASE_URL {{ARGS}}

# Start psql  command for test database
db_psql_test *ARGS:
    psql $TEST_DATABASE_URL {{ARGS}}

# Remove all database data from (./db/dev/pgdata/*)
db_delete:
    rm -rf ./db/dev/pgdata/*

