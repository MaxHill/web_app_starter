import bg_jobs
import bg_jobs/logger_event_listener
import bg_jobs/postgres_db_adapter
import bg_jobs/queue
import bg_jobs/scheduled_job
import context
import jobs/example_interval_job
import jobs/example_job
import jobs/example_scheduled_job

/// Setup logging using bg_jobs.
/// 
/// See [bg_jobs](https://hexdocs.pm/bg_jobs/) for more info
/// 
pub fn setup(ctx: context.JobContext) {
  let db_adapter = postgres_db_adapter.new(ctx.conn, [])
  let assert Ok(_) = db_adapter.migrate_up([logger_event_listener.listner])

  bg_jobs.new(db_adapter)
  |> bg_jobs.with_event_listener(logger_event_listener.listner)
  // Queues
  |> bg_jobs.with_queue(default_queue(ctx))
  // Scheduled jobs
  |> bg_jobs.with_scheduled_job(scheduled_job.new(
    example_scheduled_job.worker(),
    scheduled_job.new_interval_minutes(1),
  ))
  |> bg_jobs.with_scheduled_job(scheduled_job.new(
    example_interval_job.worker(),
    scheduled_job.new_schedule()
      |> scheduled_job.on_minute(12)
      |> scheduled_job.build_schedule(),
  ))
  |> bg_jobs.build()
}

fn default_queue(ctx: context.JobContext) {
  queue.new("default_queue")
  |> queue.with_worker(example_job.worker(ctx))
}
