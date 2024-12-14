import gleeunit/should
import providers/logging/logging_provider as log

pub fn add_context_test() {
  log.new("test_logger")
  |> log.with_context("key", "value")
  |> log.with_context("some_error", Error("test"))
  |> should.equal(
    log.LoggingContext(logger_name: "test_logger", attributes: [
      #("key", "\"value\""),
      #("some_error", "Error(\"test\")"),
    ]),
  )
}

pub fn format_context_test() {
  log.new("test_logger")
  |> log.with_context("key", "value")
  |> log.with_context("key_2", "some other value")
  |> log.format("Hello", _)
  |> should.equal(
    "test_logger: Hello                    context: [key: \"value\" | key_2: \"some other value\"]",
  )
}
