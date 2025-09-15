#!/bin/bash
# Jasmin SMS Gateway - Local Test Script
# This script tests all Jasmin services locally

set -e

echo "🧪 Testing Jasmin SMS Gateway locally..."
echo "========================================"

# Function to test HTTP endpoint
test_http_endpoint() {
    local url=$1
    local expected_status=$2
    local description=$3
    
    echo "Testing: $description"
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url" || echo "000")
    
    if [ "$response" = "$expected_status" ]; then
        echo "✅ $description - Status: $response"
    else
        echo "❌ $description - Expected: $expected_status, Got: $response"
    fi
    echo ""
}

# Function to test telnet connection
test_telnet_connection() {
    local host=$1
    local port=$2
    local description=$3
    
    echo "Testing: $description"
    if timeout 5 bash -c "echo > /dev/tcp/$host/$port" 2>/dev/null; then
        echo "✅ $description - Connection successful"
    else
        echo "❌ $description - Connection failed"
    fi
    echo ""
}

# Wait for services to start
echo "⏳ Waiting for services to start..."
sleep 10

echo "🔍 Testing HTTP API endpoints..."
test_http_endpoint "http://localhost:1401/ping" "200" "HTTP API Ping"
test_http_endpoint "http://localhost:1401/balance?username=jcliadmin&password=jclipwd" "200" "HTTP API Balance Check"

echo "🔍 Testing Management CLI..."
test_telnet_connection "localhost" "8990" "Management CLI (jCli)"

echo "🔍 Testing SMPP Server..."
test_telnet_connection "localhost" "2775" "SMPP Server"

echo "🔍 Testing RabbitMQ Management..."
test_http_endpoint "http://localhost:15672" "200" "RabbitMQ Management Interface"

echo "🔍 Testing Redis..."
if redis-cli ping | grep -q "PONG"; then
    echo "✅ Redis - Connection successful"
else
    echo "❌ Redis - Connection failed"
fi
echo ""

echo "📊 Service Status Summary:"
echo "=========================="
echo "HTTP API (1401): $(curl -s -o /dev/null -w "%{http_code}" http://localhost:1401/ping 2>/dev/null || echo "DOWN")"
echo "Management CLI (8990): $(timeout 2 bash -c "echo > /dev/tcp/localhost/8990" 2>/dev/null && echo "UP" || echo "DOWN")"
echo "SMPP Server (2775): $(timeout 2 bash -c "echo > /dev/tcp/localhost/2775" 2>/dev/null && echo "UP" || echo "DOWN")"
echo "RabbitMQ (5672): $(timeout 2 bash -c "echo > /dev/tcp/localhost/5672" 2>/dev/null && echo "UP" || echo "DOWN")"
echo "Redis (6379): $(timeout 2 bash -c "echo > /dev/tcp/localhost/6379" 2>/dev/null && echo "UP" || echo "DOWN")"

echo ""
echo "🎉 Local testing complete!"
echo ""
echo "📱 Access your local SMS gateway:"
echo "  HTTP API: http://localhost:1401"
echo "  Management CLI: telnet localhost 8990"
echo "  SMPP Server: localhost:2775"
echo "  RabbitMQ Management: http://localhost:15672"
echo ""
echo "🔐 Default credentials:"
echo "  Username: jcliadmin"
echo "  Password: jclipwd"
