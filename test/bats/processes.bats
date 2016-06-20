#!/usr/bin/env bats

load "$BATS_TEST_DIRNAME/bats_functions.bash"

@test "env process" {
  cd "$WORKING"
  run decompose env

  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "development" ]
}

@test "nginx-proxy generate configs returns 0" {
  cd "$WORKING"
  run decompose generate_nginx_proxy_configs

  [ "$status" -eq 0 ]
}

@test "Increment version tag" {
  cd "$WORKING"

  # Commit
  touch "hello123"
  git add .
  git config user.email "tester@example.com"
  git config user.name "Tester"
  git commit -m "Initial commit"
  # Create a tag
  git tag v1.0
  # Commit again
  echo "Change here" >> "hello123"
  git add .
  git commit -m "Change here"
  # Increment tag
  run decompose increment-tag
  # Verify tag was incremented
  [ "$(git describe --abbrev=0 --tags)" == "v1.1" ]

  echo "$output"
  [ "$status" -eq 0 ]
}

function setup() {
  setup_testing_environment
} 

function teardown() {
  teardown_testing_environment
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
