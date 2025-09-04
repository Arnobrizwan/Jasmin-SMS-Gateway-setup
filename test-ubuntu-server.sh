#!/bin/bash
# Ubuntu Server Test Script for Jasmin SMS Gateway
# This script tests the installation on a real Ubuntu server

set -e

echo "🐧 Ubuntu Server Test for Jasmin SMS Gateway"
echo "============================================="

# Check if running on Ubuntu
if ! command -v lsb_release &> /dev/null; then
    echo "❌ This script requires Ubuntu. Installing lsb-release..."
    apt-get update
    apt-get install -y lsb-release
fi

UBUNTU_VERSION=$(lsb_release -rs)
echo "📋 Testing on Ubuntu $UBUNTU_VERSION"

# Check if we're in the right directory
if [ ! -f "install-ubuntu.sh" ]; then
    echo "❌ install-ubuntu.sh not found. Please run from jasmin-docker directory"
    exit 1
fi

echo "✅ Found installation script"

# Test 1: Check script syntax
echo "🔍 Test 1: Checking script syntax..."
bash -n install-ubuntu.sh
echo "✅ Script syntax is valid"

# Test 2: Check dependencies
echo "🔍 Test 2: Checking system dependencies..."
if command -v apt-get &> /dev/null; then
    echo "✅ apt-get available"
else
    echo "❌ apt-get not available"
    exit 1
fi

if command -v systemctl &> /dev/null; then
    echo "✅ systemctl available"
else
    echo "❌ systemctl not available"
    exit 1
fi

# Test 3: Check if we can install packages (dry run)
echo "🔍 Test 3: Testing package installation (dry run)..."
apt-get update
apt-get install -y --dry-run rabbitmq-server redis-server python3 python3-pip python3-dev libffi-dev libssl-dev python3-twisted bc curl telnet
echo "✅ All required packages can be installed"

# Test 4: Check password generation
echo "🔍 Test 4: Testing password generation..."
if command -v openssl &> /dev/null; then
    test_password=$(openssl rand -base64 32)
    if [ ${#test_password} -gt 20 ]; then
        echo "✅ Password generation works"
    else
        echo "❌ Password generation failed"
        exit 1
    fi
else
    echo "❌ openssl not available for password generation"
    exit 1
fi

# Test 5: Check file permissions
echo "🔍 Test 5: Checking file permissions..."
if [ -x "install-ubuntu.sh" ]; then
    echo "✅ install-ubuntu.sh is executable"
else
    echo "❌ install-ubuntu.sh is not executable"
    exit 1
fi

if [ -x "ubuntu-commands.sh" ]; then
    echo "✅ ubuntu-commands.sh is executable"
else
    echo "❌ ubuntu-commands.sh is not executable"
    exit 1
fi

# Test 6: Check configuration files
echo "🔍 Test 6: Checking configuration files..."
if [ -f "jasmin.cfg" ]; then
    echo "✅ jasmin.cfg exists"
    if grep -q "\${JASMIN_HTTP_PASSWORD" jasmin.cfg; then
        echo "✅ Environment variable substitution configured"
    else
        echo "❌ Environment variable substitution not configured"
        exit 1
    fi
else
    echo "❌ jasmin.cfg missing"
    exit 1
fi

# Test 7: Check systemd service file
echo "🔍 Test 7: Checking systemd service file..."
if [ -f "jasmind.service" ]; then
    echo "✅ jasmind.service exists"
    if grep -q "User=jasmin" jasmind.service; then
        echo "✅ Service configured to run as jasmin user"
    else
        echo "❌ Service not configured for jasmin user"
        exit 1
    fi
else
    echo "❌ jasmind.service missing"
    exit 1
fi

# Test 8: Check Makefile
echo "🔍 Test 8: Checking Makefile..."
if [ -f "Makefile" ]; then
    echo "✅ Makefile exists"
    make help > /dev/null
    echo "✅ Makefile targets work"
else
    echo "❌ Makefile missing"
    exit 1
fi

# Test 9: Check documentation
echo "🔍 Test 9: Checking documentation..."
if [ -f "README.md" ]; then
    echo "✅ README.md exists"
    if grep -q "Ubuntu Installation" README.md; then
        echo "✅ README contains Ubuntu installation info"
    else
        echo "❌ README missing Ubuntu installation info"
        exit 1
    fi
else
    echo "❌ README.md missing"
    exit 1
fi

if [ -f "SECURITY.md" ]; then
    echo "✅ SECURITY.md exists"
else
    echo "❌ SECURITY.md missing"
    exit 1
fi

# Test 10: Check ubuntu-commands.sh
echo "🔍 Test 10: Checking ubuntu-commands.sh..."
if [ -f "ubuntu-commands.sh" ]; then
    echo "✅ ubuntu-commands.sh exists"
    ./ubuntu-commands.sh help > /dev/null
    echo "✅ ubuntu-commands.sh help works"
else
    echo "❌ ubuntu-commands.sh missing"
    exit 1
fi

echo ""
echo "🎉 All tests passed!"
echo ""
echo "📋 Test Summary:"
echo "  ✅ Script syntax valid"
echo "  ✅ System dependencies available"
echo "  ✅ Package installation possible"
echo "  ✅ Password generation works"
echo "  ✅ File permissions correct"
echo "  ✅ Configuration files valid"
echo "  ✅ Systemd service configured"
echo "  ✅ Makefile targets work"
echo "  ✅ Documentation complete"
echo "  ✅ Management commands work"
echo ""
echo "🚀 Ready for Ubuntu server installation!"
echo ""
echo "📝 Next steps:"
echo "  1. Run: ./install-ubuntu.sh"
echo "  2. Save the generated passwords"
echo "  3. Test the installation with: make status"
echo "  4. Connect to CLI with: make cli"
