# Webapp starter for gleam

<!-- [![Package Version](https://img.shields.io/hexpm/v/app)](https://hex.pm/packages/app) -->
<!-- [![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/app/) -->

A simple starter template for building web applications using 
[Gleam](https://gleam.run/). If you’re interested in quickly setting 
up a robust development environment for your projects, this template 
might be the perfect fit.

---

## Development system requirements
- [Gleam](https://gleam.run/)
- [Docker](https://www.docker.com/)
- [Mproc](https://github.com/pvolok/mprocs)
- [Watchexec](https://github.com/watchexec/watchexec)
- [DbMate](https://github.com/amacneil/dbmate)

## Getting started
To start the database and all watch commands run: 
```sh
  $ npm install
  $ just dev
```

---

## Database
This starter uses **PostgreSQL** as the database. 
The development and testing databases are managed using Docker.

### Database setup
- Development database configuration is managed via Docker. See the `justfile` for available commands.
- Environment variables for database settings are found in the `.env` file.
- If you modify `.env`, a database reset may be required. Use:
```sh
  $ just db_delete
  $ just db_start
```
or:
```sh
  $ just dev
```

### Testing Database

The Docker container includes a separate test database. Examples of its usage can be found in test/integration/create_guestbook_entry_test.gleam.

Tests interacting with the database can run using one of two strategies:
1. Transaction-based tests (test_db_provider.transaction_test): Code runs inside a transaction that is rolled back afterward. Faster but not always feasible.
2. Truncate-based tests (test_db_provider.truncate_test): Cleans up tables after running. Use this as a fallback.

Prefer transaction tests unless specific scenarios require truncation.

### Database Migrations

Migrations are handled using DbMate. Always use the alias `just db [...]` to 
ensure the correct environment variables are set.

Some migrations, like bg_jobs, are executed automatically at startup. 
Check `/src/providers/db/db_provider` for the setup process.


---
# Environment Variables
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
# Development

## TODO
- [x] Integration testing
- [ ] Frontend resources
- [ ] [logging](https://hexdocs.pm/flash/)
