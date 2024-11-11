import bg_jobs/jobs
import gleam/io

pub const job_name = "EXAMPLE_SCHEULED_JOB"

pub fn worker() {
  jobs.Worker(job_name: job_name, handler: handler)
}

pub fn handler(_: jobs.Job) {
  io.debug("Scheduled job triggered")
  Ok(Nil)
}
