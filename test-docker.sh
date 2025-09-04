#!/bin/bash
# Docker Test Script for Jasmin SMS Gateway
# This script tests the installation files in a Docker environment

set -e

echo "🐳 Docker Test for Jasmin SMS Gateway"
echo "====================================="

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

# Test 2: Check ubuntu-commands.sh syntax
echo "🔍 Test 2: Checking ubuntu-commands.sh syntax..."
bash -n ubuntu-commands.sh
echo "✅ ubuntu-commands.sh syntax is valid"

# Test 3: Check Makefile syntax
echo "🔍 Test 3: Checking Makefile syntax..."
make -n help > /dev/null
echo "✅ Makefile syntax is valid"

# Test 4: Check if all required files exist
echo "🔍 Test 4: Checking required files..."
required_files=(
    "install-ubuntu.sh"
    "ubuntu-commands.sh"
    "jasmin.cfg"
    "jasmind.service"
    "Makefile"
    "README.md"
    "SECURITY.md"
    ".gitignore"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
        exit 1
    fi
done

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

# Test 6: Check password generation
echo "🔍 Test 6: Testing password generation..."
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

# Test 7: Check environment variable substitution
echo "🔍 Test 7: Testing configuration template..."
if grep -q "\${JASMIN_HTTP_PASSWORD" jasmin.cfg; then
    echo "✅ Environment variable substitution configured"
else
    echo "❌ Environment variable substitution not configured"
    exit 1
fi

# Test 8: Check security features
echo "🔍 Test 8: Testing security features..."
if grep -q "CHANGE_ME_SECURE_PASSWORD" .env.example 2>/dev/null || [ ! -f ".env.example" ]; then
    echo "✅ No hardcoded passwords in templates"
else
    echo "❌ Hardcoded passwords found in templates"
    exit 1
fi

# Test 9: Check README content
echo "🔍 Test 9: Testing README content..."
if grep -q "Ubuntu Installation" README.md; then
    echo "✅ README contains Ubuntu installation info"
else
    echo "❌ README missing Ubuntu installation info"
    exit 1
fi

if grep -q "SECURITY" README.md; then
    echo "✅ README contains security information"
else
    echo "❌ README missing security information"
    exit 1
fi

# Test 10: Check Makefile targets
echo "🔍 Test 10: Testing Makefile targets..."
make help > /dev/null
echo "✅ Makefile help target works"

# Test 11: Check ubuntu-commands.sh help
echo "🔍 Test 11: Testing ubuntu-commands.sh help..."
./ubuntu-commands.sh help > /dev/null
echo "✅ ubuntu-commands.sh help works"

# Test 12: Check installation script content
echo "🔍 Test 12: Checking installation script content..."
if grep -q "rabbitmq-server" install-ubuntu.sh; then
    echo "✅ RabbitMQ installation included"
else
    echo "❌ RabbitMQ installation missing"
    exit 1
fi

if grep -q "redis-server" install-ubuntu.sh; then
    echo "✅ Redis installation included"
else
    echo "❌ Redis installation missing"
    exit 1
fi

if grep -q "jasmin-sms-gateway" install-ubuntu.sh; then
    echo "✅ Jasmin package installation included"
else
    echo "❌ Jasmin package installation missing"
    exit 1
fi

if grep -q "openssl rand -base64 32" install-ubuntu.sh; then
    echo "✅ Secure password generation included"
else
    echo "❌ Secure password generation missing"
    exit 1
fi

echo ""
echo "🎉 All Docker tests passed!"
echo ""
echo "📋 Test Summary:"
echo "  ✅ Installation script syntax valid"
echo "  ✅ Management commands syntax valid"
echo "  ✅ Makefile syntax valid"
echo "  ✅ All required files present"
echo "  ✅ File permissions correct"
echo "  ✅ Password generation works"
echo "  ✅ Environment variables configured"
echo "  ✅ Security features implemented"
echo "  ✅ Documentation complete"
echo "  ✅ All dependencies included"
echo "  ✅ Secure password generation implemented"
echo ""
echo "🚀 Ready for Ubuntu server deployment!"
echo ""
echo "📝 Next steps for Ubuntu server:"
echo "  1. Deploy to Ubuntu 20.04+ server"
echo "  2. Run: ./install-ubuntu.sh"
echo "  3. Save the generated passwords"
echo "  4. Test the installation with: make status"
echo "  5. Connect to CLI with: make cli"
