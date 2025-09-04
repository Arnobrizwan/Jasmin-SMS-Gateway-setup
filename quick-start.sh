#!/bin/bash
# Jasmin SMS Gateway Quick Start Script

set -e

echo "🚀 Jasmin SMS Gateway Quick Start"
echo "=================================="

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker-compose >/dev/null 2>&1; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose and try again."
    exit 1
fi

echo "✅ Docker and Docker Compose are available"

# Start services
echo "🚀 Starting services..."
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check if services are running
echo "🔍 Checking service status..."

# Check Redis
if docker-compose exec redis redis-cli ping >/dev/null 2>&1; then
    echo "✅ Redis is running"
else
    echo "❌ Redis is not running"
fi

# Check RabbitMQ
if docker-compose exec rabbit-mq rabbitmq-diagnostics ping >/dev/null 2>&1; then
    echo "✅ RabbitMQ is running"
else
    echo "❌ RabbitMQ is not running"
fi

# Check Jasmin
if curl -s http://localhost:1401/ping >/dev/null 2>&1; then
    echo "✅ Jasmin is running"
else
    echo "❌ Jasmin is not running"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📱 Access your SMS gateway:"
echo "  HTTP API: http://localhost:1401"
echo "  Management CLI: telnet localhost 8990"
echo "  SMPP Server: localhost:2775"
echo "  RabbitMQ Management: http://localhost:15672"
echo ""
echo "🔧 Next steps:"
echo "  1. Connect to Management CLI: telnet localhost 8990"
echo "  2. Login with: jcliadmin/jclipwd"
echo "  3. Create a user: user -a"
echo "  4. Send your first SMS!"
echo ""
echo "📚 For more information, see README.md"
