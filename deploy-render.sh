#!/bin/bash
# Deploy Jasmin SMS Gateway to Render.com

set -e

echo "🚀 Deploying Jasmin SMS Gateway to Render.com"
echo "=============================================="

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "📦 Initializing Git repository..."
    git init
    git add .
    git commit -m "Initial commit: Jasmin SMS Gateway setup"
fi

# Check if render CLI is installed
if ! command -v render >/dev/null 2>&1; then
    echo "❌ Render CLI is not installed."
    echo "Please install it from: https://render.com/docs/cli"
    echo ""
    echo "Or use the web interface at: https://render.com"
    exit 1
fi

# Login to Render (if not already logged in)
echo "🔐 Checking Render authentication..."
if ! render auth whoami >/dev/null 2>&1; then
    echo "Please login to Render:"
    render auth login
fi

# Create or update service
echo "🚀 Deploying to Render..."
render services create --file render.yaml

echo ""
echo "✅ Deployment initiated!"
echo ""
echo "📱 Your SMS gateway will be available at:"
echo "  - HTTP API: https://your-service-name.onrender.com"
echo "  - Management CLI: telnet your-service-name.onrender.com 8990"
echo "  - SMPP Server: your-service-name.onrender.com:2775"
echo ""
echo "🔧 Next steps:"
echo "  1. Wait for deployment to complete (5-10 minutes)"
echo "  2. Check the Render dashboard for service URLs"
echo "  3. Connect to Management CLI to configure users"
echo "  4. Start sending SMS!"
echo ""
echo "📚 For more information, see README.md"
