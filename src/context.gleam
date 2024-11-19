import bg_jobs
import pog

pub type WebContext {
  WebContext(conn: pog.Connection, bg: bg_jobs.BgJobs)
}

pub type JobContext {
  JobContext(conn: pog.Connection)
}
