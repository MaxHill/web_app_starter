import gleam/dynamic
import gleam/json
import gleam/option
import gleam/result
import kv_sessions
import kv_sessions/actor_adapter
import kv_sessions/postgres_adapter
import kv_sessions/session
import kv_sessions/session_config
import pog

pub fn setup(conn: pog.Connection) {
  use _ <- result.map(postgres_adapter.migrate_up(conn))

  session_config.Config(
    default_expiry: session.ExpireIn(60 * 60),
    cookie_name: "SESSION_COOKIE",
    store: postgres_adapter.new(conn),
    // cache: option.Some(ets_adapter.new("sessions_cache_table")),
    cache: option.None,
  )
}

pub fn setup_test() {
  use store <- result.map(actor_adapter.new())
  session_config.Config(
    default_expiry: session.ExpireIn(60 * 60),
    cookie_name: "TEST_SESSION_COOKIE",
    store:,
    cache: option.None,
  )
}

pub fn user_to_json(email: String) {
  json.string(email)
  |> json.to_string
}

pub fn user_from_json(json) {
  dynamic.string(json)
}

pub fn user_key(current_session: kv_sessions.CurrentSession) {
  current_session
  |> kv_sessions.key("user")
  |> kv_sessions.with_codec(decoder: user_from_json, encoder: user_to_json)
}
