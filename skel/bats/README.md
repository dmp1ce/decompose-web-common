# Skeleton Tests

These tests are intended to test the library and carry over to the project using this library to test using the skeleton.

# Usage

There are two ways to run the tests. If you have your environment setup to run all the tests, then you can just run `bats ./`. The parent project should have a `run_tests_full.bash` script which can run the tests in Docker if test dependencies are missing.

To verify that your environment can run tests, run `bats environment.bats`.
