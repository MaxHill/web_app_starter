import context
import web/controllers/guestbook_controller
import web/middleware
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: context.WebContext) -> Response {
  use req <- middleware.middleware(req)

  case wisp.path_segments(req) {
    [] -> guestbook_controller.handle(req, ctx)
    _ -> wisp.not_found()
  }
}
