import bg_jobs/jobs
import context
import providers/logging/logging_provider as log

pub const job_name = "EXAMPLE_INTERVAL_JOB"

pub fn worker(ctx: context.JobContext) {
  jobs.Worker(job_name: job_name, handler: handler(ctx, _))
}

pub fn handler(ctx: context.JobContext, _: jobs.Job) {
  ctx.log_ctx
  |> log.with_context("job_name", job_name)
  |> log.log_info("Interval job triggered")
  Ok(Nil)
}
