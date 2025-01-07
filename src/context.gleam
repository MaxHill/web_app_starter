import bg_jobs
import kv_sessions/session_config
import pog
import providers/logging/logging_provider as log

pub type WebContext {
  WebContext(
    conn: pog.Connection,
    log_ctx: log.LoggingContext,
    session: session_config.Config,
    bg: bg_jobs.BgJobs,
  )
}

pub type JobContext {
  JobContext(conn: pog.Connection, log_ctx: log.LoggingContext)
}
