import bg_jobs
import gleam/pgo

pub type WebContext {
  WebContext(conn: pgo.Connection, bg: bg_jobs.BgJobs)
}

pub type JobContext {
  JobContext(conn: pgo.Connection)
}
