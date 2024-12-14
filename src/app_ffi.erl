-module(app_ffi).
-export([start_logger/0, test_logger/0]).


start_logger() ->
    application:start(logger).

test_logger() -> logger:info("Logger has been started successfully").

