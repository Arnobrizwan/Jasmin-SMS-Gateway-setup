#!/bin/bash
echo "🚀 Starting Jasmin SMS Gateway locally..."
cd ~/jasmin-test
export JASMIN_CONFIG_FILE=~/jasmin-test/jasmin.cfg
export JASMIN_LOG_DIR=~/jasmin-test/logs
export JASMIN_STORE_DIR=~/jasmin-test/store

# Start Jasmin
jasmind --config-file=~/jasmin-test/jasmin.cfg
