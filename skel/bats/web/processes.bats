#!/usr/bin/env bats

load "$BATS_TEST_DIRNAME/bats_functions.bash"

@test "env process" {
  cd "$WORKING"
  run decompose env

  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "development" ]
}

function setup() {
  setup_testing_environment
} 

function teardown() {
  teardown_testing_environment
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
