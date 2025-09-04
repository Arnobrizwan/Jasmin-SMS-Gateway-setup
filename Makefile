# Jasmin SMS Gateway Docker Setup

.PHONY: help up down restart ps logs status clean test monitoring-up monitoring-down

# Default target
help:
	@echo "Jasmin SMS Gateway Docker Setup"
	@echo ""
	@echo "Commands:"
	@echo "  up              - Start all services"
	@echo "  down            - Stop all services"
	@echo "  restart         - Restart all services"
	@echo "  ps              - Show running containers"
	@echo "  logs            - Follow logs"
	@echo "  status          - Check service status"
	@echo "  test            - Test SMS sending"
	@echo "  monitoring-up   - Start with monitoring (Grafana + Prometheus)"
	@echo "  monitoring-down - Stop monitoring services"
	@echo "  clean           - Remove all containers and volumes"
	@echo "  help            - Show this help"

# Start services
up:
	@echo "🚀 Starting Jasmin SMS Gateway..."
	docker-compose up -d
	@echo "✅ Services started!"
	@echo "📱 HTTP API: http://localhost:1401"
	@echo "🔧 Management CLI: telnet localhost 8990"
	@echo "📡 SMPP Server: localhost:2775"
	@echo "🐰 RabbitMQ Management: http://localhost:15672"

# Stop services
down:
	@echo "🛑 Stopping services..."
	docker-compose down
	@echo "✅ Services stopped!"

# Restart services
restart:
	@echo "🔄 Restarting services..."
	docker-compose restart
	@echo "✅ Services restarted!"

# Show running containers
ps:
	@echo "📊 Running containers:"
	docker-compose ps

# Follow logs
logs:
	@echo "📋 Following logs (Ctrl+C to exit)..."
	docker-compose logs -f

# Check status
status:
	@echo "🏥 Service status:"
	@echo "Redis: $$(docker-compose exec redis redis-cli ping 2>/dev/null || echo 'Not running')"
	@echo "RabbitMQ: $$(docker-compose exec rabbit-mq rabbitmq-diagnostics ping 2>/dev/null || echo 'Not running')"
	@echo "Jasmin: $$(curl -s http://localhost:1401/ping 2>/dev/null || echo 'Not running')"

# Test SMS sending
test:
	@echo "📱 Testing SMS sending..."
	@curl -s "http://localhost:1401/send?username=foo&password=bar&to=1234567890&content=Test%20SMS" || echo "❌ Test failed - make sure services are running"

# Start with monitoring
monitoring-up:
	@echo "🚀 Starting Jasmin SMS Gateway with monitoring..."
	docker-compose -f docker-compose.monitoring.yml up -d
	@echo "✅ Services with monitoring started!"
	@echo "📱 HTTP API: http://localhost:1401"
	@echo "🔧 Management CLI: telnet localhost 8990"
	@echo "📡 SMPP Server: localhost:2775"
	@echo "🐰 RabbitMQ Management: http://localhost:15672"
	@echo "📊 Prometheus: http://localhost:9090"
	@echo "📈 Grafana: http://localhost:3000 (admin/admin)"

# Stop monitoring services
monitoring-down:
	@echo "🛑 Stopping monitoring services..."
	docker-compose -f docker-compose.monitoring.yml down
	@echo "✅ Monitoring services stopped!"

# Clean up
clean:
	@echo "🧹 Cleaning up..."
	docker-compose down -v
	docker-compose -f docker-compose.monitoring.yml down -v
	docker system prune -f
	@echo "✅ Cleanup complete!"