import dot_env/env
import gleam/int
import gleam/option
import gleam/result
import pog

/// Setup application db connection
///
/// During development, see .env for details
/// In production, see fly.toml
pub fn setup() {
  use conf <- result.map(db_conf())
  pog.connect(conf)
}

/// Create the pgo config
///
pub fn db_conf() {
  use db_host <- result.try(env.get_string("DB_HOST"))
  use db_port <- result.try(env.get_int("DB_HOST_PORT"))
  use db_name <- result.try(env.get_string("DB_NAME"))
  use db_user <- result.try(env.get_string("DB_USER"))
  use db_password <- result.map(env.get_string("DB_PASSWORD"))

  pog.default_config()
  |> pog.host(db_host)
  |> pog.port(db_port)
  |> pog.user(db_user)
  |> pog.database(db_name)
  |> pog.password(option.Some(db_password))
  |> pog.pool_size(15)
}

/// Construct a postgres connection url from the individual env parameters
///
pub fn db_url(conf: pog.Config) {
  let assert option.Some(password) = conf.password

  "postgres://"
  <> conf.user
  <> ":"
  <> password
  <> "@"
  <> conf.host
  <> ":"
  <> int.to_string(conf.port)
  <> "/"
  <> conf.database
  <> "?sslmode=disable"
}
