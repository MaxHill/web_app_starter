import config/db/db_setup
import pog

pub fn setup_transaction(f: fn(pog.Connection) -> a) {
  let assert Ok(db_conf) = db_setup.db_conf_test()
  let conn = pog.connect(db_conf)
  let _ =
    pog.transaction(conn, fn(conn) {
      f(conn)
      Error("rollback")
    })
  pog.disconnect(conn)
}

pub fn setup_clear(f: fn(pog.Connection) -> a) {
  let assert Ok(db_conf) = db_setup.db_conf_test()
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
