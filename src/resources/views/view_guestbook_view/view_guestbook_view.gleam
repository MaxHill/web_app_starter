import gleam/list
import gleam/option
import lustre/attribute as a
import lustre/element/html as h
import models/guestbook_model/guestbook_model

pub fn render(
  messages: List(guestbook_model.GuestbookMessage),
  user: option.Option(String),
) {
  let messages =
    messages
    |> list.map(fn(message) {
      h.li([], [
        h.a([a.href("mailto:" <> message.email |> option.unwrap(""))], [
          h.text(message.name),
        ]),
        h.text(" - "),
        h.text(message.message),
      ])
    })

  let user = option.unwrap(user, "guest")

  h.html([], [
    h.head([], [
      h.title([], "Gleam web-app-starter"),
      h.meta([
        a.name("viewport"),
        a.attribute("content", "width=device-width, initial-scale=1"),
      ]),
    ]),
    h.body([], [
      h.div([], [h.text("User: " <> user)]),
      h.div([], [
        h.h1([], [h.text("Messages:")]),
        h.ul([], messages),
        h.form([a.method("POST")], [
          h.label([a.for("name")], [h.text("Name")]),
          h.input([a.name("name"), a.type_("text")]),
          h.label([a.for("email")], [h.text("Email")]),
          h.input([a.name("email"), a.type_("email")]),
          h.label([a.for("message")], [h.text("Message")]),
          h.textarea([a.name("message")], ""),
          h.button([a.type_("submit")], [h.text("Send")]),
        ]),
      ]),
    ]),
  ])
}
