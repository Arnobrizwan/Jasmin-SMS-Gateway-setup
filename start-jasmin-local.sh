#!/bin/bash
# Jasmin SMS Gateway - Local macOS Startup Script
# This script starts Jasmin with proper configuration for local testing

set -e

echo "🚀 Starting Jasmin SMS Gateway locally..."

# Change to the test directory
cd /Users/arnobrizwan/jasmin-test

# Set environment variables to override hardcoded paths
export JASMIN_LOG_DIR="/Users/arnobrizwan/jasmin-test/logs"
export JASMIN_STORE_DIR="/Users/arnobrizwan/jasmin-test/store"
export JASMIN_ETC_DIR="/Users/arnobrizwan/jasmin-test/etc"

# Create required directories if they don't exist
mkdir -p "$JASMIN_LOG_DIR" "$JASMIN_STORE_DIR" "$JASMIN_ETC_DIR"

# Check if Redis is running
if ! redis-cli ping > /dev/null 2>&1; then
    echo "❌ Redis is not running. Please start Redis first:"
    echo "   brew services start redis"
    exit 1
fi

# Check if RabbitMQ is running
if ! /opt/homebrew/opt/rabbitmq/sbin/rabbitmq-diagnostics ping > /dev/null 2>&1; then
    echo "❌ RabbitMQ is not running. Please start RabbitMQ first:"
    echo "   brew services start rabbitmq"
    exit 1
fi

echo "✅ Dependencies are running"

# Start Jasmin with the local configuration
echo "🚀 Starting Jasmin daemon..."
python3 /Users/arnobrizwan/.pyenv/versions/3.11.9/lib/python3.11/site-packages/jasmin/bin/jasmind.py -c jasmin-local.cfg
