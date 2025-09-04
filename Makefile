# Jasmin SMS Gateway Docker Setup

.PHONY: help up down restart ps logs status clean test deploy-hf

# Default target
help:
	@echo "Jasmin SMS Gateway Docker Setup"
	@echo ""
	@echo "Commands:"
	@echo "  up          - Start all services"
	@echo "  down        - Stop all services"
	@echo "  restart     - Restart all services"
	@echo "  ps          - Show running containers"
	@echo "  logs        - Follow logs"
	@echo "  status      - Check service status"
	@echo "  test        - Test SMS sending"
	@echo "  clean       - Remove all containers and volumes"
	@echo "  deploy-hf   - Deploy to Hugging Face Spaces"
	@echo "  help        - Show this help"

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

# Clean up
clean:
	@echo "🧹 Cleaning up..."
	docker-compose down -v
	docker system prune -f
	@echo "✅ Cleanup complete!"

# Deploy to Hugging Face Spaces
deploy-hf:
	@echo "🚀 Deploying to Hugging Face Spaces..."
	@echo "1. Go to https://huggingface.co/spaces"
	@echo "2. Click 'Create new Space'"
	@echo "3. Choose 'Docker' as SDK"
	@echo "4. Connect your GitHub repository"
	@echo "5. Your SMS gateway will be deployed automatically!"
	@echo ""
	@echo "📱 After deployment, your SMS gateway will be available at:"
	@echo "  - Web Interface: https://your-username-jasmin-sms-gateway.hf.space"
	@echo "  - HTTP API: https://your-username-jasmin-sms-gateway.hf.space/api/send"
	@echo "  - Health Check: https://your-username-jasmin-sms-gateway.hf.space/api/health"