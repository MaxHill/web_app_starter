import gleam/list
import gleam/result
import gleam/string
import wisp

pub fn setup() {
  wisp.configure_logger()
  wisp.set_logger_level(wisp.DebugLevel)
}

pub type LoggingAttribute(a, b) =
  #(a, b)

pub type LoggingContext {
  LoggingContext(logger_name: String, attributes: List(#(String, String)))
}

pub fn new(logger_name: String) {
  LoggingContext(logger_name:, attributes: [])
}

pub fn with_context(logging_ctx: LoggingContext, a: String, b) {
  let b = string.inspect(b)

  LoggingContext(
    ..logging_ctx,
    attributes: list.append(logging_ctx.attributes, [#(a, b)]),
  )
}

pub fn format(message: String, logging_ctx: LoggingContext) {
  let context_string =
    logging_ctx.attributes
    |> list.map(format_attributes)
    |> string.join(with: ", ")

  logging_ctx.logger_name <> ": " <> message <> "    |" <> context_string
}

fn format_attributes(kv: #(String, String)) {
  kv.0 <> "=" <> kv.1
}

// re-export wisp logging
//---------------

pub fn log_emergency(ctx: LoggingContext, message: String) {
  wisp.log_emergency(format(message, ctx))
}

pub fn log_alert(ctx: LoggingContext, message: String) {
  wisp.log_alert(format(message, ctx))
}

pub fn log_critical(ctx: LoggingContext, message: String) {
  wisp.log_critical(format(message, ctx))
}

pub fn log_error(ctx: LoggingContext, message: String) {
  wisp.log_error(format(message, ctx))
}

pub fn log_warning(ctx: LoggingContext, message: String) {
  wisp.log_warning(format(message, ctx))
}

pub fn log_notice(ctx: LoggingContext, message: String) {
  wisp.log_notice(format(message, ctx))
}

pub fn log_info(ctx: LoggingContext, message: String) {
  wisp.log_info(format(message, ctx))
}

pub fn log_debug(ctx: LoggingContext, message: String) {
  wisp.log_debug(format(message, ctx))
}
