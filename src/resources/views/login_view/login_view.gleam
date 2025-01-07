import lustre/attribute as a
import lustre/element/html as h

pub fn render() {
  h.html([], [
    h.head([], [
      h.title([], "Gleam web-app-starter - login"),
      h.meta([
        a.name("viewport"),
        a.attribute("content", "width=device-width, initial-scale=1"),
      ]),
    ]),
    h.body([], [
      h.div([], [
        h.h1([], [h.text("Login:")]),
        h.form([a.method("POST")], [
          h.label([a.for("email")], [h.text("Email")]),
          h.input([a.name("email"), a.type_("email")]),
          h.button([a.type_("submit")], [h.text("Login")]),
        ]),
      ]),
    ]),
  ])
}
