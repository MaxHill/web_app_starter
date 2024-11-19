import gleam/list
import gleam/option
import gleam/result
import models/guestbook_model/sql
import pog

pub type GuestbookMessage {
  GuestbookMessage(
    id: Int,
    name: String,
    email: option.Option(String),
    message: String,
    created_at: #(#(Int, Int, Int), #(Int, Int, Int)),
  )
}

pub fn get_all_messages(conn: pog.Connection) {
  sql.get_all_messages(conn)
  |> result.map(fn(response) {
    let pog.Returned(_count, row) = response
    row
  })
  |> result.map(fn(rows) {
    rows
    |> list.map(fn(row) {
      GuestbookMessage(
        id: row.id,
        name: row.name,
        email: row.email,
        message: row.message,
        created_at: timestamp_to_erlang(row.created_at),
      )
    })
  })
}

pub fn create_message(
  conn: pog.Connection,
  name name: String,
  email email: String,
  message message: String,
  date date: #(#(Int, Int, Int), #(Int, Int, Int)),
) {
  sql.create_message(conn, name, email, message, erlang_to_timestamp(date))
  |> result.map(fn(response) {
    let pog.Returned(_count, row) = response
    row
  })
  |> result.map(fn(rows) {
    rows
    |> list.map(fn(row) {
      GuestbookMessage(
        id: row.id,
        name: row.name,
        email: row.email,
        message: row.message,
        created_at: timestamp_to_erlang(row.created_at),
      )
    })
  })
}

fn erlang_to_timestamp(timestamp: #(#(Int, Int, Int), #(Int, Int, Int))) {
  let #(#(year, month, day), #(hour, minute, seconds)) = timestamp
  pog.Timestamp(pog.Date(year, month, day), pog.Time(hour, minute, seconds, 0))
}

fn timestamp_to_erlang(timestamp: pog.Timestamp) {
  let pog.Timestamp(
    pog.Date(year, month, day),
    pog.Time(hour, minute, seconds, _milliesecond),
  ) = timestamp

  #(#(year, month, day), #(hour, minute, seconds))
}
