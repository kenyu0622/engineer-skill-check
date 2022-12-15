#!/bin/bash
SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR/..
export NODE_OPTIONS=--openssl-legacy-provider
bundle install
rm tmp/pids/server.pid
 bundle exec rails s -b 0.0.0.0
#tail -f /dev/null
