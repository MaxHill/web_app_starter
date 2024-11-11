import context
import dot_env as dot
import dot_env/env
import gleam/erlang/process
import gleam/option
import gleam/pgo
import jobs
import web
import wisp

pub fn main() {
  dot.new()
  |> dot.set_path(".env")
  |> dot.set_debug(False)
  |> dot.load

  // Setup db connection
  let assert Ok(db_host) = env.get_string("DB_HOST")
  let assert Ok(db_port) = env.get_int("DB_HOST_PORT")
  let assert Ok(db_name) = env.get_string("DB_NAME")
  let assert Ok(db_user) = env.get_string("DB_USER")
  let assert Ok(db_password) = env.get_string("DB_PASSWORD")
  let conn =
    pgo.connect(
      pgo.Config(
        ..pgo.default_config(),
        host: db_host,
        port: db_port,
        user: db_user,
        database: db_name,
        password: option.Some(db_password),
        pool_size: 15,
      ),
    )

  // Setup logger
  wisp.configure_logger()

  // Setup jobs process
  let assert Ok(bg_jobs) = jobs.setup(context.JobContext(conn))

  // Setup webserver process
  let assert Ok(_webserver) = web.setup(context.WebContext(conn, bg_jobs))

  process.sleep_forever()
}
