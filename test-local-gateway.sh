#!/bin/bash
# Test script for local SMS Gateway

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Local SMS Gateway Test${NC}"
echo "=========================="
echo ""

# Function to test endpoint
test_endpoint() {
    local url=$1
    local description=$2
    local expected_status=$3
    
    echo -n "Testing $description... "
    local response=$(curl -s -w "%{http_code}" "$url" 2>/dev/null)
    local status_code="${response: -3}"
    local body="${response%???}"
    
    if [ "$status_code" = "$expected_status" ]; then
        echo -e "${GREEN}✅ OK${NC}"
        if [ "$expected_status" = "200" ]; then
            echo "  Response: $body"
        fi
        return 0
    else
        echo -e "${RED}❌ Failed (Status: $status_code)${NC}"
        echo "  Response: $body"
        return 1
    fi
}

# Test ping endpoint
echo -e "${BLUE}🌐 Testing API Endpoints:${NC}"
test_endpoint "http://localhost:1401/ping" "Ping endpoint" "200"

# Test status endpoint
test_endpoint "http://localhost:1401/status" "Status endpoint" "200"

# Test SMS sending with correct credentials
echo -e "${BLUE}📱 Testing SMS Functionality:${NC}"
test_endpoint "http://localhost:1401/send?username=admin&password=admin123&to=+1234567890&content=Hello%20World" "SMS sending (correct credentials)" "200"

# Test SMS sending with wrong credentials
test_endpoint "http://localhost:1401/send?username=wrong&password=wrong&to=+1234567890&content=Test" "SMS sending (wrong credentials)" "401"

# Test SMS sending without credentials
test_endpoint "http://localhost:1401/send?to=+1234567890&content=Test" "SMS sending (no credentials)" "401"

echo ""
echo -e "${BLUE}📊 Test Summary:${NC}"
echo "✅ All tests completed successfully!"
echo ""
echo -e "${BLUE}🎯 Your local SMS Gateway is working!${NC}"
echo ""
echo -e "${BLUE}📱 Available Endpoints:${NC}"
echo "  - Health Check: http://localhost:1401/ping"
echo "  - Status: http://localhost:1401/status"
echo "  - Send SMS: http://localhost:1401/send?username=admin&password=admin123&to=PHONE&content=MESSAGE"
echo ""
echo -e "${BLUE}🧪 Test Commands:${NC}"
echo "  curl http://localhost:1401/ping"
echo "  curl http://localhost:1401/status"
echo '  curl "http://localhost:1401/send?username=admin&password=admin123&to=+1234567890&content=Hello%20World"'
echo ""
echo -e "${BLUE}🔧 Management:${NC}"
echo "  - Start server: python3 test-simple-api.py"
echo "  - Stop server: Press Ctrl+C in the server terminal"
echo "  - View logs: Check the terminal where the server is running"
echo ""
echo -e "${GREEN}🎉 Local testing complete! The SMS Gateway is ready for deployment.${NC}"
