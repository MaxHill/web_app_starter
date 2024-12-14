import context
import dot_env
import gleam/erlang/process
import providers/db/db_provider
import providers/jobs/jobs_provider
import providers/logging/logging_provider as log
import providers/web_server/web_server_provider

pub fn main() {
  dot_env.new()
  |> dot_env.load

  // Setup database connection
  let assert Ok(conn) = db_provider.setup()

  // Setup logger
  log.setup()
  let test_logger =
    log.new("test_logger")
    |> log.with_context("thing", "stuff")

  test_logger |> log.log_info("hello")

  // Setup jobs process
  let assert Ok(bg_jobs) =
    jobs_provider.setup(context.JobContext(conn, log.new("jobs_logger")))

  // Setup webserver process
  let assert Ok(_webserver) =
    web_server_provider.setup(context.WebContext(
      conn,
      log.new("web_logger"),
      bg_jobs,
    ))

  process.sleep_forever()
}
