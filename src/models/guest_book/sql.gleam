import decode/zero
import gleam/option.{type Option}
import gleam/pgo

/// A row you get from running the `create_message` query
/// defined in `./src/models/guest_book/sql/create_message.sql`.
///
/// > 🐿️ This type definition was generated automatically using v1.8.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type CreateMessageRow {
  CreateMessageRow(
    id: Int,
    name: String,
    email: Option(String),
    message: String,
    created_at: #(#(Int, Int, Int), #(Int, Int, Int)),
  )
}

/// Runs the `create_message` query
/// defined in `./src/models/guest_book/sql/create_message.sql`.
///
/// > 🐿️ This function was generated automatically using v1.8.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn create_message(db, arg_1, arg_2, arg_3, arg_4) {
  let decoder = {
    use id <- zero.field(0, zero.int)
    use name <- zero.field(1, zero.string)
    use email <- zero.field(2, zero.optional(zero.string))
    use message <- zero.field(3, zero.string)
    use created_at <- zero.field(4, timestamp_decoder())
    zero.success(CreateMessageRow(id:, name:, email:, message:, created_at:))
  }

  "INSERT INTO
    guestbook (name, email, message, created_at)
VALUES
    ($1, $2, $3, $4)
RETURNING
    *
"
  |> pgo.execute(
    db,
    [pgo.text(arg_1), pgo.text(arg_2), pgo.text(arg_3), pgo.timestamp(arg_4)],
    zero.run(_, decoder),
  )
}

/// A row you get from running the `get_all_messages` query
/// defined in `./src/models/guest_book/sql/get_all_messages.sql`.
///
/// > 🐿️ This type definition was generated automatically using v1.8.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetAllMessagesRow {
  GetAllMessagesRow(
    id: Int,
    name: String,
    email: Option(String),
    message: String,
    created_at: #(#(Int, Int, Int), #(Int, Int, Int)),
  )
}

/// Runs the `get_all_messages` query
/// defined in `./src/models/guest_book/sql/get_all_messages.sql`.
///
/// > 🐿️ This function was generated automatically using v1.8.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_all_messages(db) {
  let decoder = {
    use id <- zero.field(0, zero.int)
    use name <- zero.field(1, zero.string)
    use email <- zero.field(2, zero.optional(zero.string))
    use message <- zero.field(3, zero.string)
    use created_at <- zero.field(4, timestamp_decoder())
    zero.success(GetAllMessagesRow(id:, name:, email:, message:, created_at:))
  }

  "SELECT
    *
FROM
    guestbook
"
  |> pgo.execute(db, [], zero.run(_, decoder))
}

// --- Encoding/decoding utils -------------------------------------------------

/// A decoder to decode `timestamp`s coming from a Postgres query.
///
fn timestamp_decoder() {
  use dynamic <- zero.then(zero.dynamic)
  case pgo.decode_timestamp(dynamic) {
    Ok(timestamp) -> zero.success(timestamp)
    Error(_) -> zero.failure(#(#(0, 0, 0), #(0, 0, 0)), "timestamp")
  }
}
