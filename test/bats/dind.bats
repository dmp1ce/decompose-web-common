#!/usr/bin/env bats

TESTER_IMAGE="docker run --rm --link decompose-docker-web-testing:docker docker run --rm tester"

@test "env process" {
  run $TESTER_IMAGE sh -c "cd /app && \
decompose env"

  echo "$output"
  [ "$status" -eq 0 ]
  [ "${lines[1]}" = "development" ]
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
