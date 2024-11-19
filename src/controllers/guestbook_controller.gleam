import context
import gleam/io
import gleam/list
import gleam/result
import gleam/string_builder
import jobs/example_job
import models/guestbook_model/guestbook_model
import resources/views/view_guestbook_view/view_guestbook_view
import wisp

pub fn get(_req: wisp.Request, ctx: context.WebContext) -> wisp.Response {
  let guestbook_messages = guestbook_model.get_all_messages(ctx.conn)

  case guestbook_messages {
    Ok(guestbook_messages) -> {
      wisp.html_response(view_guestbook_view.render(guestbook_messages), 200)
    }
    Error(e) -> {
      io.debug(e)
      wisp.html_response(string_builder.from_string("oops"), 500)
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
