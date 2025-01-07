import decode/zero
import gleam/option.{type Option}
import pog

/// A row you get from running the `create_message` query
/// defined in `./src/models/guestbook_model/sql/create_message.sql`.
///
/// > 🐿️ This type definition was generated automatically using v2.0.5 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type CreateMessageRow {
  CreateMessageRow(
    id: Int,
    name: String,
    email: Option(String),
    message: String,
    created_at: pog.Timestamp,
  )
}

/// Runs the `create_message` query
/// defined in `./src/models/guestbook_model/sql/create_message.sql`.
///
/// > 🐿️ This function was generated automatically using v2.0.5 of
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

  let query = "INSERT INTO
    guestbook (name, email, message, created_at)
VALUES
    ($1, $2, $3, $4)
RETURNING
    *
"

  pog.query(query)
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.text(arg_3))
  |> pog.parameter(pog.timestamp(arg_4))
  |> pog.returning(zero.run(_, decoder))
  |> pog.execute(db)
}

/// A row you get from running the `get_all_messages` query
/// defined in `./src/models/guestbook_model/sql/get_all_messages.sql`.
///
/// > 🐿️ This type definition was generated automatically using v2.0.5 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetAllMessagesRow {
  GetAllMessagesRow(
    id: Int,
    name: String,
    email: Option(String),
    message: String,
    created_at: pog.Timestamp,
  )
}

/// Runs the `get_all_messages` query
/// defined in `./src/models/guestbook_model/sql/get_all_messages.sql`.
///
/// > 🐿️ This function was generated automatically using v2.0.5 of
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

  let query = "SELECT
    *
FROM
    guestbook
"

  pog.query(query)
  |> pog.returning(zero.run(_, decoder))
  |> pog.execute(db)
}

// --- Encoding/decoding utils -------------------------------------------------

/// A decoder to decode `timestamp`s coming from a Postgres query.
///
fn timestamp_decoder() {
  use dynamic <- zero.then(zero.dynamic)
  case pog.decode_timestamp(dynamic) {
    Ok(timestamp) -> zero.success(timestamp)
    Error(_) -> {
      let date = pog.Date(0, 0, 0)
      let time = pog.Time(0, 0, 0, 0)
      zero.failure(pog.Timestamp(date:, time:), "timestamp")
    }
  }
}
