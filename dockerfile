# Multi-stage Dockerfile using separate build and runtime containers.
# 
# Benefits of this setup:
# 1. **Smaller Deployment Image**: Final container includes only what’s needed to run, keeping it lightweight.
# 2. **Version Control**: Easy to specify exact versions of Erlang and Gleam.
# 3. **Faster Rebuilds**: Only the build stage is cached, making rebuilds more efficient.

FROM erlang:27.1.1.0-alpine AS build
COPY --from=ghcr.io/gleam-lang/gleam:v1.5.1-erlang-alpine /bin/gleam /bin/gleam
COPY . /app/
RUN cd /app && gleam export erlang-shipment 

FROM erlang:27.1.1.0-alpine
COPY --from=build /app/build/erlang-shipment /app
WORKDIR /app
ENTRYPOINT [/app/entrypoint.sh]
CMD[run]
