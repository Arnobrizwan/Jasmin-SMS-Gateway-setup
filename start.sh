#!/bin/bash
# Start Complete Jasmin SMS Gateway with Py4Web GUI

echo "🚀 Starting Complete Jasmin SMS Gateway with Py4Web GUI..."

# Create necessary directories
mkdir -p logs
mkdir -p store
mkdir -p apps/jasmin_smsc_gui/uploads

# Check if Redis is running
if ! redis-cli ping > /dev/null 2>&1; then
    echo "❌ Redis is not running. Please start Redis first:"
    echo "   brew services start redis"
    echo "   or"
    echo "   redis-server"
    exit 1
fi

# Check if RabbitMQ is running
if ! rabbitmq-diagnostics ping > /dev/null 2>&1; then
    echo "❌ RabbitMQ is not running. Please start RabbitMQ first:"
    echo "   brew services start rabbitmq"
    echo "   or"
    echo "   rabbitmq-server"
    exit 1
fi

# Start Jasmin with jcli support in the background
echo "🎯 Starting Jasmin SMS Gateway with jcli support..."
python3 jasmin-with-jcli.py &
JASMIN_PID=$!

# Wait for Jasmin to start
echo "⏳ Waiting for Jasmin to start..."
sleep 5

# Check if Jasmin HTTP API is running
echo "🔍 Checking Jasmin HTTP API..."
if ! curl -s http://localhost:1401/ping | grep -q "pong"; then
    echo "❌ Jasmin HTTP API not responding. Please check configuration."
    kill $JASMIN_PID 2>/dev/null
    exit 1
fi

echo "✅ Jasmin SMS Gateway started successfully"

# Start Py4Web GUI
echo "🌐 Starting Py4Web GUI..."
echo "📱 SMS Gateway API: http://localhost:1401"
echo "🔧 Management CLI: telnet localhost 8990"
echo "🌐 Py4Web GUI: http://localhost:8000/jasmin_smsc_gui"
echo ""
echo "Press Ctrl+C to stop all services"
echo "=" * 50

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "🛑 Stopping services..."
    kill $JASMIN_PID 2>/dev/null
    pkill -f jasmin-with-jcli.py 2>/dev/null
    pkill -f py4web 2>/dev/null
    echo "✅ All services stopped"
    exit 0
}

# Set trap to cleanup on script exit
trap cleanup SIGINT SIGTERM

# Start Py4Web
py4web run apps --host 0.0.0.0 --port 8000 --password_file password.txt
