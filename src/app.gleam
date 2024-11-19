import config/db/db_setup
import config/jobs/jobs_setup
import config/logging/logging_setup
import config/webserver/webserver_setup
import context
import dot_env
import gleam/erlang/process

// import lib/assets

pub fn main() {
  // let assert Ok(_) = assets.read_vite_manifest()

  dot_env.new()
  |> dot_env.set_path(".env")
  |> dot_env.set_debug(False)
  |> dot_env.load

  // Setup database connection
  let assert Ok(conn) = db_setup.setup()

  // Setup logger
  logging_setup.setup()

  // Setup jobs process
  let assert Ok(bg_jobs) = jobs_setup.setup(context.JobContext(conn))

  // Setup webserver process
  let assert Ok(_webserver) =
    webserver_setup.setup(context.WebContext(conn, bg_jobs))

  process.sleep_forever()
}
