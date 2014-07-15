#!/usr/bin/env bash
set -e

./jenkins-tests.sh
bundle exec rake publish_gem
