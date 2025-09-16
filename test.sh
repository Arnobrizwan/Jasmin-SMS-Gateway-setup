#!/bin/bash
# Test Complete Jasmin SMS Gateway with Py4Web GUI

echo "🧪 Testing Complete Jasmin SMS Gateway with Py4Web GUI..."
echo ""

# Test Jasmin HTTP API
echo "1. Testing Jasmin HTTP API..."
if curl -s http://localhost:1401/ping | grep -q "pong"; then
    echo "   ✅ HTTP API working"
else
    echo "   ❌ HTTP API not running"
    echo "   Start with: ./start.sh"
    exit 1
fi

# Test Jasmin Status
echo "2. Testing Jasmin Status..."
if curl -s http://localhost:1401/status | grep -q "jcli"; then
    echo "   ✅ Status API working (jcli enabled)"
else
    echo "   ❌ Status API failed"
fi

# Test SMS Sending
echo "3. Testing SMS Sending..."
response=$(curl -s "http://localhost:1401/send?username=\${JASMIN_HTTP_USERNAME:-admin}&password=\${JASMIN_HTTP_PASSWORD:-changeme123}&to=+1234567890&content=Test%20Message")
if echo "$response" | grep -q "success"; then
    echo "   ✅ SMS sending working"
    echo "   Response: $response"
else
    echo "   ❌ SMS sending failed"
    echo "   Response: $response"
fi

# Test jcli Connection
echo "4. Testing jcli Connection..."
if echo "quit" | telnet localhost 8990 2>/dev/null | grep -q "Authentication required"; then
    echo "   ✅ jcli server accessible"
else
    echo "   ⚠️  jcli server not responding (may be normal)"
fi

# Test Py4Web
echo "5. Testing Py4Web..."
if curl -s http://localhost:8000 | grep -q "html"; then
    echo "   ✅ Py4Web accessible"
else
    echo "   ❌ Py4Web not running"
fi

# Test Py4Web GUI
echo "6. Testing Py4Web GUI..."
if curl -s http://localhost:8000/jasmin_smsc_gui | grep -q "DOCTYPE html"; then
    echo "   ✅ Py4Web GUI working"
else
    echo "   ❌ Py4Web GUI not accessible"
fi

echo ""
echo "🎉 System testing completed!"
echo ""
echo "📱 Available services:"
echo "   - SMS Gateway API: http://localhost:1401"
echo "   - Management CLI: telnet localhost 8990"
echo "   - Py4Web GUI: http://localhost:8000/jasmin_smsc_gui"
echo ""
echo "🔧 Test commands:"
echo "   curl http://localhost:1401/ping"
echo "   curl http://localhost:1401/status"
echo '   curl "http://localhost:1401/send?username=\${JASMIN_HTTP_USERNAME:-admin}&password=\${JASMIN_HTTP_PASSWORD:-changeme123}&to=+1234567890&content=Hello%20World"'
echo "   telnet localhost 8990"
echo ""
echo "🌐 Access the Py4Web GUI at: http://localhost:8000/jasmin_smsc_gui"
