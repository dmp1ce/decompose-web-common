#!/bin/bash

function setup_testing_environment() {
  echo "Setting up Docker testing environment ..."
  # Create dind daemon with a mount to project.
  testing_env_build=$(docker run --privileged --name decompose-docker-web-testing -d docker:dind)
  [ "$?" == "1" ] && echo "$testing_env_build"

  # Build testing image
  local project_directory=$(readlink -f "$DIR/../")
  # Copy volume so we can safely dereference symlinks
  # Create docker container for doing tests
  testing_env_build=$(docker run -v $project_directory:/project --rm --link decompose-docker-web-testing:docker docker sh -c "cp -rL /project /project-no-symlinks && docker build -t tester /project-no-symlinks/test/bats/fixtures/docker-compose/.")
  [ "$?" == "1" ] && echo "$testing_env_build"
}

function run_tests() {
  echo "Running BATS tests"
  bats "$DIR/bats/dind.bats"
}

function teardown_testing_environment() {
  echo "Teardown Docker testing environment ..."
  testing_env_cleanup=$(docker rm -f decompose-docker-web-testing)
  [ "$?" == "1" ] && echo "$testing_env_cleanup"
}

