import context
import dot_env
import gleam/erlang/process
import providers/db/db_provider
import providers/jobs/jobs_provider
import providers/logging/logging_provider
import providers/web_server/web_server_provider

pub fn main() {
  dot_env.new()
  |> dot_env.load

  // Setup database connection
  let assert Ok(conn) = db_provider.setup()

  // Setup logger
  logging_provider.setup()

  // Setup jobs process
  let assert Ok(bg_jobs) = jobs_provider.setup(context.JobContext(conn))

  // Setup webserver process
  let assert Ok(_webserver) =
    web_server_provider.setup(context.WebContext(conn, bg_jobs))

  process.sleep_forever()
}
