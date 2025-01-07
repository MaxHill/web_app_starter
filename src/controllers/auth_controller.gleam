import context
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import kv_sessions
import kv_sessions/session
import lustre/element
import providers/logging/logging_provider as log
import providers/sessions/sessions_provider
import resources/views/login_view/login_view
import wisp

pub fn get(_req: wisp.Request, ctx: context.WebContext) -> wisp.Response {
  ctx.log_ctx |> log.log_info("Someone will try to login soon")

  wisp.html_response(
    login_view.render()
      |> element.to_document_string_builder,
    200,
  )
}

pub fn post(req: wisp.Request, ctx: context.WebContext) -> wisp.Response {
  use formdata <- wisp.require_form(req)
  let assert Ok(email) = {
    use email <- result.try(list.key_find(formdata.values, "email"))
    Ok(email)
  }

  // Do login logic

  // Create a new session
  let new_session =
    session.builder()
    |> session.with_entry("user", sessions_provider.user_to_json(email))
    |> session.with_expiry(session.ExpireIn(60 * 60))
    |> session.build()

  kv_sessions.CurrentSession(req, ctx.session)
  |> kv_sessions.replace_session(wisp.redirect("/"), new_session)
  |> result.unwrap(wisp.internal_server_error())
}
