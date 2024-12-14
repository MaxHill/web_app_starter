import bg_jobs
import bg_jobs/jobs
import context
import gleam/dynamic
import gleam/json
import gleam/result
import providers/logging/logging_provider as log

pub const job_name = "EXAMPLE_JOB"

pub type Payload {
  Payload(message: String)
}

pub fn worker(ctx: context.JobContext) {
  jobs.Worker(job_name: job_name, handler: handler(ctx, _))
}

pub fn handler(ctx: context.JobContext, job: jobs.Job) {
  use Payload(payload) <- result.try(
    from_string(job.payload)
    |> result.map_error(fn(_e) { "Could not decode payload" }),
  )

  ctx.log_ctx
  |> log.with_context("job_name", job_name)
  |> log.with_context("job_payload", payload)
  |> log.log_info("Triggered job")

  Ok(Nil)
}

pub fn dispatch(bg: bg_jobs.BgJobs, message message: String) {
  bg_jobs.new_job(job_name, to_string(Payload(message)))
  |> bg_jobs.enqueue(bg)
}

fn to_string(send_email_job: Payload) {
  json.object([#("message", json.string(send_email_job.message))])
  |> json.to_string
}

fn from_string(json_string: String) -> Result(Payload, json.DecodeError) {
  json.decode(
    from: json_string,
    using: dynamic.decode1(
      Payload,
      dynamic.field("message", of: dynamic.string),
    ),
  )
}
