#!/bin/bash
# SMS Gateway Dashboard Startup Script

echo "🚀 Starting SMS Gateway Dashboard..."
echo ""

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Error: Python 3 is not installed!"
    echo "💡 Install Python 3 and try again"
    exit 1
fi

# Check if dashboard.html exists
if [ ! -f "dashboard.html" ]; then
    echo "❌ Error: dashboard.html not found!"
    echo "💡 Make sure you're in the correct directory"
    exit 1
fi

# Start the dashboard server
echo "📱 Dashboard will open in your browser automatically"
echo "🌐 Dashboard URL: http://localhost:8080/dashboard.html"
echo "⏹️  Press Ctrl+C to stop the server"
echo ""

python3 serve-dashboard.py
