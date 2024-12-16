# Webapp starter for gleam

<!-- [![Package Version](https://img.shields.io/hexpm/v/app)](https://hex.pm/packages/app) -->
<!-- [![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/app/) -->

A simple starter template for building web applications using 
[Gleam](https://gleam.run/). 

---

## Provided:
- Development / testing database using docker and [pog](https://github.com/lpil/pog)
- Logging setup
- Background jobs setup using [bg_jobs](https://hexdocs.pm/bg_jobs/)
- (WIP) Production docker image and fly.toml
- (WIP) Frontend configuration using [vite](https://vite.dev/) for css and ts
- (TODO) Session management using [kv_sessions](https://hexdocs.pm/wisp_kv_sessions/index.html)
- (TODO) Email provider
- (TODO) Auth

## Development system requirements
- [Gleam](https://gleam.run/)
- [Docker](https://www.docker.com/)
- [Mproc](https://github.com/pvolok/mprocs)
- [Watchexec](https://github.com/watchexec/watchexec)
- [DbMate](https://github.com/amacneil/dbmate)

## Getting started
To start developing
```sh
  $ just dev
```
This starts: 
- Database - (dockerized postgres)
- Dev server - (wisp server)
- Query generation - (squirrel)
- tests - (gleeunit)
Dev server, Query generation and tests are all started in watch mode, 
see `justfile` for more info.

This is all started in a mproc instance so it's easy to switch between them.

## Environment Variables
- Development: Configure in .env.
- Production: Set in fly.toml.

---

# Project structure
```
├── db
│   ├── dev
│   │   └── mnt_data
│   └── migrations
├── src
│   ├── controllers
│   ├── jobs
│   ├── lib
│   ├── models
│   │   └── guestbook_model
│   │       └── sql
│   ├── providers
│   │   ├── cache
│   │   ├── db
│   │   ├── jobs
│   │   ├── logging
│   │   └── web_server
│   ├── resources
│   │   ├── css
│   │   ├── js
│   │   └── views
│   │       └── view_guestbook_view
│   └── routes
│       └── middlewares
└── test
    └── integration
```

## /db
Contains database migrations and development database configurations.
<!-- TODO: Add documentation for `mnt_data` and `pgdata` folders. -->

## /src/app.gleam
The main entry point of the application. This is where everything is wired up.

## /src/context.gleam
Defines two context types:
- For routing and controllers.
- For background jobs.

## /src/controllers
Controllers handle incoming requests and define application logic. 
Each route points to a controller.

## /src/jobs
Background jobs are managed here. For example, to send emails, create 
`/src/jobs/send_email_job.gleam`. This project uses [bg_jobs](https://hexdocs.pm/bg_jobs/).

## /src/models
The interface for database operations. Models encapsulate resource-specific 
logic and data interaction.

## /src/providers
Providers offer specific functionalities like database access, email sending, 
or logging.

## /src/resources
Contains rendering-related code such as CSS, JavaScript, and views. 
Note: Static files should be placed in `/static`.

<!-- TODO: Update when `/static` is fully implemented. -->

## /src/routes
Defines application routes and their associated controllers. 
Middleware configuration is also located here under `/src/routes/middlewares`.

## /test/integration
Write integration tests here to simulate user workflows.

---
# Context
JobContext and WebContext is passed to the web_server and jobs, it 
contains the db connection and other useful values that should not be 
constructed in place. This makes testing easier since you can construct 
separate testing dependencies.

# Logging provider
Sets up the erlang default logger using wisp, also provides a context-builder 
and logging functions for context aware logging.
Separate log contexts are passed to jobs and web_server using the 
`context.JobContext` and `context.WebContext` respectivly.

There is also a `log_request_middleware` that logs requests and adds a 
request_id to the logging context, the logging context is passed to 
the controllers using context.WebContext.


Create a new logging context 
```gleam
import providers/logging/logging_provider as log

// Create a new log_context
let example_logger = log.new("example_logger")
|> with_context("thing", "value")

// Log message to info level
example_logger |> log.log_info("some log value")
// -> INFO example_logger: some log value    |thing="value"
```

# Jobs provider
Provides setup function that configures [bg_jos](https://hexdocs.pm/bg_jobs/). 
This is also where you register your jobs.
# Web_server provider
Provides setup function for starting 
[mist](https://hexdocs.pm/mist/index.html) - [wisp](https://hexdocs.pm/wisp/)


# Database
This starter uses **PostgreSQL** as the database. 
The starter provides:
- Development/testing database setup using docker, read more below
- Database migrations using DbMate
- Integration testing setup with postgres

## Database setup
- Development database configuration is managed via Docker. See the `justfile` for available commands.
- Environment variables for database settings are found in the `.env` file.
- If you modify `.env`, a database reset may be required. Use:
```sh
  $ just db_delete
  $ just db_start
```

# Db provider
Provides setup and helper functions related to setting up and connecting to the database.

## Testing Database
The Docker container includes a separate test database. Examples of 
its usage can be found in `test/integration/create_guestbook_entry_test.gleam`.

Tests interacting with the database can run using one of two strategies:
1. Transaction-based tests (test_db_provider.transaction_test): Code 
  runs inside a transaction that is rolled back afterward. Faster but not always feasible.
2. Truncate-based tests (test_db_provider.truncate_test): Cleans up 
  tables after running. Use this as a fallback.

Prefer transaction tests unless specific scenarios require truncation.

## Database Migrations

Migrations are handled using DbMate. Always use the alias `just db [...]` to 
ensure the correct environment variables are set.

Some migrations, like bg_jobs, are executed automatically at startup. 
Check `/src/providers/db/db_provider` for the setup process.


