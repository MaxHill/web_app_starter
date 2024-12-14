import bg_jobs
import pog
import providers/logging/logging_provider as log

pub type WebContext {
  WebContext(
    conn: pog.Connection,
    log_ctx: log.LoggingContext,
    bg: bg_jobs.BgJobs,
  )
}

pub type JobContext {
  JobContext(conn: pog.Connection, log_ctx: log.LoggingContext)
}
