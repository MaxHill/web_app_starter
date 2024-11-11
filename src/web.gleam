import context
import mist
import web/router
import wisp
import wisp/wisp_mist

pub fn setup(ctx: context.WebContext) {
  let secret_key_base = wisp.random_string(64)

  // Start the Mist web server.
  wisp_mist.handler(router.handle_request(_, ctx), secret_key_base)
  |> mist.new
  |> mist.port(8000)
  |> mist.start_http
}
