#!/bin/bash
# Jasmin SMS Gateway - Ubuntu Management Commands

case "$1" in
    "start")
        echo "🚀 Starting Jasmin SMS Gateway services..."
        sudo systemctl start redis-server
        sudo systemctl start rabbitmq-server
        sudo systemctl start jasmind
        echo "✅ Services started!"
        ;;
    "stop")
        echo "🛑 Stopping Jasmin SMS Gateway services..."
        sudo systemctl stop jasmind
        sudo systemctl stop rabbitmq-server
        sudo systemctl stop redis-server
        echo "✅ Services stopped!"
        ;;
    "restart")
        echo "🔄 Restarting Jasmin SMS Gateway services..."
        sudo systemctl restart redis-server
        sudo systemctl restart rabbitmq-server
        sudo systemctl restart jasmind
        echo "✅ Services restarted!"
        ;;
    "status")
        echo "🏥 Service status:"
        echo "Redis: $(sudo systemctl is-active redis-server)"
        echo "RabbitMQ: $(sudo systemctl is-active rabbitmq-server)"
        echo "Jasmin: $(sudo systemctl is-active jasmind)"
        echo ""
        echo "🔍 Health checks:"
        redis-cli ping 2>/dev/null || echo "Redis: Not responding"
        sudo rabbitmq-diagnostics ping 2>/dev/null || echo "RabbitMQ: Not responding"
        curl -s http://localhost:1401/ping 2>/dev/null || echo "Jasmin: Not responding"
        ;;
    "logs")
        echo "📄 Showing Jasmin logs (Ctrl+C to exit)..."
        sudo journalctl -u jasmind -f
        ;;
    "test")
        echo "📱 Testing SMS sending..."
        curl -s "http://localhost:1401/send?username=foo&password=bar&to=1234567890&content=Test%20SMS" || echo "❌ Test failed - make sure services are running and user 'foo' exists"
        ;;
    "cli")
        echo "🔧 Connecting to Management CLI..."
        echo "Use Ctrl+] then 'quit' to exit"
        telnet localhost 8990
        ;;
    "help")
        echo "Jasmin SMS Gateway - Ubuntu Management Commands"
        echo ""
        echo "Usage: ./ubuntu-commands.sh [command]"
        echo ""
        echo "Commands:"
        echo "  start     - Start all services"
        echo "  stop      - Stop all services"
        echo "  restart   - Restart all services"
        echo "  status    - Check service status"
        echo "  logs      - Follow Jasmin logs"
        echo "  test      - Test SMS sending"
        echo "  cli       - Connect to Management CLI"
        echo "  help      - Show this help"
        ;;
    *)
        echo "❌ Unknown command: $1"
        echo "Use './ubuntu-commands.sh help' for available commands"
        exit 1
        ;;
esac
