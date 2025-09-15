#!/bin/bash
# Test script for server deployment
# This script tests the deployed Jasmin SMS Gateway

set -e

SERVER_IP="203.18.159.132"

echo "🧪 Testing Jasmin SMS Gateway on server..."
echo "Server: $SERVER_IP"
echo "=========================================="

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

echo "🔍 Testing HTTP API endpoints..."
test_http_endpoint "http://$SERVER_IP:1401/ping" "200" "HTTP API Ping"
test_http_endpoint "http://$SERVER_IP:1401/balance?username=jcliadmin&password=jclipwd" "200" "HTTP API Balance Check"

echo "🔍 Testing Management CLI..."
test_telnet_connection "$SERVER_IP" "8990" "Management CLI (jCli)"

echo "🔍 Testing SMPP Server..."
test_telnet_connection "$SERVER_IP" "2775" "SMPP Server"

echo "🔍 Testing RabbitMQ Management..."
test_http_endpoint "http://$SERVER_IP:15672" "200" "RabbitMQ Management Interface"

echo "📊 Service Status Summary:"
echo "=========================="
echo "HTTP API (1401): $(curl -s -o /dev/null -w "%{http_code}" http://$SERVER_IP:1401/ping 2>/dev/null || echo "DOWN")"
echo "Management CLI (8990): $(timeout 2 bash -c "echo > /dev/tcp/$SERVER_IP/8990" 2>/dev/null && echo "UP" || echo "DOWN")"
echo "SMPP Server (2775): $(timeout 2 bash -c "echo > /dev/tcp/$SERVER_IP/2775" 2>/dev/null && echo "UP" || echo "DOWN")"
echo "RabbitMQ (5672): $(timeout 2 bash -c "echo > /dev/tcp/$SERVER_IP/5672" 2>/dev/null && echo "UP" || echo "DOWN")"

echo ""
echo "🎉 Server testing complete!"
echo ""
echo "📱 Access your SMS gateway:"
echo "  HTTP API: http://$SERVER_IP:1401"
echo "  Management CLI: telnet $SERVER_IP 8990"
echo "  SMPP Server: $SERVER_IP:2775"
echo "  RabbitMQ Management: http://$SERVER_IP:15672"
echo ""
echo "🔐 Default credentials:"
echo "  Username: jcliadmin"
echo "  Password: jclipwd"
