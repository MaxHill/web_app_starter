import context
import gleam/io
import gleam/list
import gleam/option
import gleam/result
import jobs/example_job
import kv_sessions
import lustre/element
import models/guestbook_model/guestbook_model
import providers/logging/logging_provider as log
import providers/sessions/sessions_provider
import resources/views/view_guestbook_view/view_guestbook_view
import wisp

pub fn get(req: wisp.Request, ctx: context.WebContext) -> wisp.Response {
  let guestbook_messages = guestbook_model.get_all_messages(ctx.conn)

  let assert Ok(current_user) =
    kv_sessions.CurrentSession(req, ctx.session)
    |> sessions_provider.user_key()
    |> kv_sessions.get()
    |> io.debug

  ctx.log_ctx |> log.log_info("Someone browsed to the guestbook")

  case guestbook_messages {
    Ok(guestbook_messages) -> {
      wisp.html_response(
        view_guestbook_view.render(guestbook_messages, current_user)
          |> element.to_document_string_builder,
        200,
      )
    }
    Error(e) -> {
      io.debug(e)
      wisp.internal_server_error()
    }
  }
}

pub fn post(req: wisp.Request, ctx: context.WebContext) -> wisp.Response {
  use formdata <- wisp.require_form(req)
  let assert Ok(#(name, email, message)) = {
    use name <- result.try(list.key_find(formdata.values, "name"))
    use email <- result.try(list.key_find(formdata.values, "email"))
    use message <- result.try(list.key_find(formdata.values, "message"))
    Ok(#(name, email, message))
  }

  let assert Ok(_) =
    guestbook_model.create_message(
      ctx.conn,
      name,
      email,
      message,
      #(#(2024, 01, 01), #(01, 01, 01)),
    )

  let assert Ok(_) = example_job.dispatch(ctx.bg, message)

  wisp.redirect("/")
}
