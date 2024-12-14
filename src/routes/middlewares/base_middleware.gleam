import context
import providers/logging/log_request_middleware
import wisp

pub fn middleware(
  req: wisp.Request,
  ctx: context.WebContext,
  handle_request: fn(#(wisp.Request, context.WebContext)) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use ctx <- log_request_middleware.log_request(ctx, req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)

  handle_request(#(req, ctx))
}
