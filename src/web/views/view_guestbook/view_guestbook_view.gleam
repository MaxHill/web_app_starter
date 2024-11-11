import gleam/list
import gleam/string
import gleam/string_builder
import models/guestbook_model

pub fn render(messages: List(guestbook_model.GuestbookMessage)) {
  let t =
    messages
    |> list.map(fn(message) { "<li>" <> message.message <> "</li>" })
    |> string.join("")
  string_builder.from_string("<h1>Messages:</h1><ul>" <> t <> "</ul>" <> form)
}

const form = "<form method=\"POST\"> 
    <label>
    Name:
   <input name=\"name\" type=\"text\"/> 
    </label>
    <label>
    Email:
   <input name=\"email\" type=\"email\"/> 
    </label>
    <label>
    Message:
   <textarea name=\"message\"> </textarea>
    </label>
    <button type=\"submit\">Send</button> 
</form>"
