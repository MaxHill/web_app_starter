import context
import controllers/auth_controller
import controllers/guestbook_controller
import gleam/http
import routes/middlewares/base_middleware
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: context.WebContext) -> Response {
  use #(req, ctx) <- base_middleware.middleware(req, ctx)

  case wisp.path_segments(req) {
    ["login"] ->
      case req.method {
        http.Get -> auth_controller.get(req, ctx)
        http.Post -> auth_controller.post(req, ctx)
        _ -> wisp.method_not_allowed(allowed: [http.Get, http.Post])
      }

    [] ->
      case req.method {
        http.Get -> guestbook_controller.get(req, ctx)
        http.Post -> guestbook_controller.post(req, ctx)
        _ -> wisp.method_not_allowed(allowed: [http.Get, http.Post])
      }

    _ -> wisp.not_found()
  }
}
