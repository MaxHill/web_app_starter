import bg_jobs/events
import providers/logging/logging_provider as log

/// Listen to events and logg them using the [logging](https://hexdocs.pm/logging/) library
///
pub fn listner(ctx: log.LoggingContext, event: events.Event) {
  case event {
    events.JobEnqueuedEvent(job) ->
      ctx
      |> log.with_context("job_name", job.name)
      |> log.with_context("job_payload", job.payload)
      |> log.log_info("JobEnqueued")
    events.JobFailedEvent(queue_name, job) ->
      ctx
      |> log.with_context("queue_name", queue_name)
      |> log.with_context("job_name", job.name)
      |> log.with_context("job_payload", job.payload)
      |> log.log_info("JobFailed")
    events.JobReservedEvent(queue_name, job) ->
      ctx
      |> log.with_context("queue_name", queue_name)
      |> log.with_context("job_name", job.name)
      |> log.with_context("job_payload", job.payload)
      |> log.log_info("JobReserved")
    events.JobStartEvent(queue_name, job) ->
      ctx
      |> log.with_context("queue_name", queue_name)
      |> log.with_context("job_name", job.name)
      |> log.with_context("job_payload", job.payload)
      |> log.log_info("JobStart")
    events.JobSucceededEvent(queue_name, job) ->
      ctx
      |> log.with_context("queue_name", queue_name)
      |> log.with_context("job_name", job.name)
      |> log.log_info("JobSucceeded")
    events.QueueErrorEvent(queue_name, error) ->
      ctx
      |> log.with_context("queue_name", queue_name)
      |> log.with_context("error", error)
      |> log.log_error("QueueError")
    events.QueuePollingStartedEvent(queue_name) ->
      ctx
      |> log.with_context("queue_name", queue_name)
      |> log.log_debug("QueuePollingStarted")
    events.QueuePollingStopedEvent(queue_name) ->
      ctx
      |> log.with_context("queue_name", queue_name)
      |> log.log_debug("QueuePollingStoped")
    events.DbQueryEvent(sql, attributes) ->
      ctx
      |> log.with_context("sql", sql)
      |> log.with_context("attributes", attributes)
      |> log.log_debug("DbQuery")
    events.DbResponseEvent(response) ->
      ctx
      |> log.with_context("response", response)
      |> log.log_debug("DbResponseEvent")
    events.DbErrorEvent(error) ->
      ctx
      |> log.with_context("error", error)
      |> log.log_error("DbError")
    events.SetupErrorEvent(error) ->
      ctx
      |> log.with_context("error", error)
      |> log.log_error("SetupError")
    events.DbEvent(action, input) ->
      ctx
      |> log.with_context("action", action)
      |> log.with_context("input", input)
      |> log.log_debug("DbEvent")
    events.MigrateDownComplete ->
      ctx
      |> log.log_info("SetupError")

    events.MigrateUpComplete ->
      ctx
      |> log.log_info("MigrateUpComplete")
    events.MonitorReleasingReserved(pid) ->
      ctx
      |> log.with_context("pid", pid)
      |> log.log_info("MonitorReleasingReserved")
    events.MonitorReleasedJob(job) ->
      ctx
      |> log.with_context("job", job)
      |> log.log_info("MonitorReleasedJob")
    events.NoWorkerForJobError(job_request) ->
      ctx
      |> log.with_context("job_request", job_request)
      |> log.log_info("MonitorReleasedJob")
  }
  Nil
}
