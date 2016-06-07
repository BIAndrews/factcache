#!/bin/bash
#
#  Script to quickly run all syntax, lint, and rspec tests
#

echo "Running lint test..."
bundle exec rake lint 2>/dev/null
test $? -ne 0 && exit $?;

echo "Running syntax test..."
bundle exec rake syntax 2>/dev/null
test $? -ne 0 && exit $?;

echo "Running PF metadata_lint test..."
bundle exec rake metadata_lint 2>/dev/null
test $? -ne 0 && exit $?;

echo "Running rSpec tests..."
bundle exec rake test 2>/dev/null
test $? -ne 0 && exit $?;
