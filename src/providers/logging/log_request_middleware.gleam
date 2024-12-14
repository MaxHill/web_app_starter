import context
import gleam/http
import gleam/int
import gleam/string
import providers/logging/logging_provider as log
import tempo/duration
import wisp.{type Request, type Response}
import youid/uuid

pub fn log_request(
  ctx: context.WebContext,
  req: Request,
  handler: fn(context.WebContext) -> Response,
) -> Response {
  let id = uuid.v7_string()

  let start = duration.start_monotonic()
  let log_ctx = ctx.log_ctx |> log.with_context("request_id", id)
  let ctx = context.WebContext(..ctx, log_ctx:)

  ctx.log_ctx
  |> log.log_info(
    "Request started: "
    <> string.uppercase(http.method_to_string(req.method))
    <> " "
    <> req.path,
  )

  let response = handler(ctx)

  ctx.log_ctx
  |> log.with_context("status", response.status)
  |> log.with_context(
    "method",
    string.uppercase(http.method_to_string(req.method)),
  )
  |> log.with_context(
    "time_elapsed",
    duration.stop_monotonic(start)
      |> duration.format(),
  )
  |> log.log_info(
    "Response: "
    <> int.to_string(response.status)
    <> " "
    <> string.uppercase(http.method_to_string(req.method))
    <> " "
    <> req.path,
  )
  response
}
