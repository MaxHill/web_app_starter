import bg_jobs
import bg_jobs/jobs
import bg_jobs/postgres_db_adapter
import bg_jobs/queue
import context
import dot_env
import gleam/list
import gleam/otp/static_supervisor as sup
import gleam/string
import gleeunit/should
import models/guestbook_model/guestbook_model
import providers/db/test_db_provider
import providers/logging/logging_provider as log
import routes/routes
import wisp/testing

pub fn setup(f: fn(context.WebContext) -> a) {
  // Setup connection
  dot_env.new() |> dot_env.load

  use conn <- test_db_provider.transaction_test()

  let db_adapter = postgres_db_adapter.new(conn, [])
  let assert Ok(bg) =
    sup.new(sup.OneForOne)
    |> bg_jobs.new(db_adapter)
    |> bg_jobs.with_queue(
      queue.new("test_queue")
      |> queue.with_worker(
        jobs.Worker(job_name: "EXAMPLE_JOB", handler: fn(_) { Ok(Nil) }),
      ),
    )
    |> bg_jobs.build()

  let ctx = context.WebContext(conn: conn, log_ctx: log.new("test"), bg: bg)

  f(ctx)
}

pub fn create_guestbook_entry_test() {
  use ctx <- setup()
  //  Make post request
  let _ =
    testing.post_form("/", [], [
      #("name", "Joe"),
      #("email", "joe@email.com"),
      #("message", "This is the message"),
    ])
    |> routes.handle_request(ctx)
    |> fn(res) {
      res.status
      |> should.equal(303)

      res.headers
      |> list.contains(#("location", "/"))
    }

  // Make get request
  let res =
    testing.get("/", [])
    |> routes.handle_request(ctx)

  // Validate the posted message is shown on page
  res
  |> testing.string_body()
  |> string.contains("This is the message")
  |> should.be_true()

  // Validate there is a form with correct input
  res
  |> testing.string_body()
  |> fn(str) {
    str |> string.contains("form method=\"POST\"") |> should.be_true()
    str |> string.contains("input name=\"name\"") |> should.be_true()
    str |> string.contains("input name=\"email\"") |> should.be_true()
    str |> string.contains("button type=\"submit\"") |> should.be_true()
  }

  guestbook_model.get_all_messages(ctx.conn)
  |> should.be_ok
  |> list.length()
  |> should.equal(1)
}
