// import config/db/db_setup
// import gleam/int
// import gleam/io
// import gleam/string
// import gleamyshell
//
// pub fn up() {
//   execute("up")
// }
//
// pub fn drop() {
//   execute("drop")
// }
//
// pub fn create() {
//   execute("create")
// }
//
// fn execute(command: String) {
//   io.debug(#("running: ", command))
//   let assert Ok(db_url) = db_setup.test_db_url()
//   case
//     gleamyshell.execute("dbmate", in: ".", args: [
//       "--url",
//       db_url,
//       "--migrations-dir",
//       "./db/migrations",
//       command,
//     ])
//   {
//     Ok(gleamyshell.CommandOutput(0, response)) -> {
//       io.debug(string.trim(response))
//       Nil
//     }
//     Ok(gleamyshell.CommandOutput(exit_code, output)) -> {
//       io.debug(
//         "Whoops!\nError ("
//         <> int.to_string(exit_code)
//         <> "): "
//         <> string.trim(output),
//       )
//       Nil
//     }
//     Error(reason) -> {
//       io.debug("Fatal: " <> reason)
//       Nil
//     }
//   }
// }
