import dot_env/env
import gleam/result
import pog
import providers/db/db_provider

/// Create the db_config to use in integration tests
/// 
/// By default this uses the same credentials as the dev database with the exception
/// of database name wich is read from the DB_TEST_NAME environment variable
/// 
pub fn db_conf_test() {
  use db_name <- result.try(env.get_string("DB_TEST_NAME"))
  use db_conf <- result.map(db_provider.db_conf())

  pog.Config(..db_conf, database: db_name)
}

/// Setup database connection for integration tests using the test config
///
pub fn setup_test() {
  use conf <- result.map(db_conf_test())
  pog.connect(conf)
}

/// Run a test within a transaction that is rolled back at the end of the test 
///
/// This is faster than `truncate_test` since nothing is comitted
///
pub fn transaction_test(f: fn(pog.Connection) -> a) {
  let assert Ok(db_conf) = db_conf_test()
  let conn = pog.connect(db_conf)
  let _ =
    pog.transaction(conn, fn(conn) {
      f(conn)
      Error("rollback")
    })
  pog.disconnect(conn)
}

/// Run a test and then truncate all tables in the database.
///
/// This is slower than `transaction_test` but may be necessary in some cases.
/// Prefere `transaction_test` if possible
///
pub fn truncate_test(f: fn(pog.Connection) -> a) {
  let assert Ok(db_conf) = db_conf_test()
  let conn = pog.connect(db_conf)

  // Truncate all tables except 'schema_migrations'
  let assert Ok(_) =
    "
      DO $$ 
  DECLARE
      table_name text;
  BEGIN
      -- Loop through all tables except 'schema_migrations'
      FOR table_name IN 
          SELECT tablename 
          FROM pg_tables
          WHERE schemaname = 'public' AND tablename != 'schema_migrations' 
      LOOP
          -- Execute the TRUNCATE statement for each table
          EXECUTE 'TRUNCATE TABLE public.' || quote_ident(table_name) || ' CASCADE';
      END LOOP;
  END $$;
      "
    |> pog.query()
    |> pog.execute(conn)

  f(conn)

  pog.disconnect(conn)
}
