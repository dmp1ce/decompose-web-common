Run the `run_tests_full.bash` script to run tests

Because of expensive environment setup, the `run_tests_full.bash` script wraps the `bats` command. [This](https://github.com/sstephenson/bats/issues/3) issue may change the need for a wrapper script in the future.

# Docker wrapper

These tests use a Docker wrapper. The wrapper is intended to make it easier to see test results, without needing to install several test dependencies. Although, the wrapper does slow down the tests.

To avoid using a Docker wrapper, run the tests directly using `bats skel/bats` from the root of this project. For active development, use this method.
