import gleam/list
import gleam/option
import gleam/pgo
import gleam/result
import models/guest_book/sql

pub type GuestbookMessage {
  GuestbookMessage(
    id: Int,
    name: String,
    email: option.Option(String),
    message: String,
    created_at: #(#(Int, Int, Int), #(Int, Int, Int)),
  )
}

pub fn get_all_messages(conn: pgo.Connection) {
  sql.get_all_messages(conn)
  |> result.map(fn(response) {
    let pgo.Returned(_count, row) = response
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
        created_at: row.created_at,
      )
    })
  })
}

pub fn create_message(
  conn: pgo.Connection,
  name name: String,
  email email: String,
  message message: String,
  date date: #(#(Int, Int, Int), #(Int, Int, Int)),
) {
  sql.create_message(conn, name, email, message, date)
  |> result.map(fn(response) {
    let pgo.Returned(_count, row) = response
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
        created_at: row.created_at,
      )
    })
  })
}
