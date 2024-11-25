import bg_jobs/logger_event_listener
import bg_jobs/postgres_db_adapter
import gleeunit
import pog
import providers/db/test_db_provider

pub fn main() {
  let assert Ok(conf) = test_db_provider.db_conf_test()
  let conn = pog.connect(conf)
  let db_adapter =
    postgres_db_adapter.new(conn, [logger_event_listener.listner])
  let assert Ok(_) = db_adapter.migrate_up([logger_event_listener.listner])
  pog.disconnect(conn)

  gleeunit.main()
}
