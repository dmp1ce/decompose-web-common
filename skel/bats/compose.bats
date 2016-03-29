#!/usr/bin/env bats

# These tests build the Docker Compose containers and verify their functionality.

load "$BATS_TEST_DIRNAME/bats_functions.bash"

@test "'decompose nginx_proxy_docker_compose' works without error" {
  cd "$WORKING"
  pwd
  run decompose nginx_proxy_docker_compose version

  echo "$output"
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" == "docker-compose version"* ]]
}

@test "'decompose start_nginx_proxy' starts nginx-proxy" {
  cd "$WORKING"
  decompose nginx_proxy_docker_compose ps
  nginx_proxy_containers=$(docker ps | grep nginx_proxy)

  [ "$(echo $nginx_proxy_containers | wc -l)" -gt 0 ] 
}

function setup() {
  setup_testing_environment

  # Start nginx-proxy
  cd "$WORKING"
  decompose --build
  decompose start_nginx_proxy
} 

function teardown() {
  teardown_testing_environment
  
  # Remove nginx-proxy
  docker rm -f nginx_proxy
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
