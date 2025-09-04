# Jasmin SMS Gateway - Ubuntu Setup

.PHONY: help install start stop restart status logs test cli clean

# Default target
help:
	@echo "Jasmin SMS Gateway - Ubuntu Setup"
	@echo ""
	@echo "Commands:"
	@echo "  install    - Install Jasmin SMS Gateway on Ubuntu"
	@echo "  start      - Start all services"
	@echo "  stop       - Stop all services"
	@echo "  restart    - Restart all services"
	@echo "  status     - Check service status"
	@echo "  logs       - Follow Jasmin logs"
	@echo "  test       - Test SMS sending"
	@echo "  cli        - Connect to Management CLI"
	@echo "  clean      - Remove installation"
	@echo "  help       - Show this help"

# Install Jasmin SMS Gateway
install:
	@echo "🚀 Installing Jasmin SMS Gateway on Ubuntu..."
	@chmod +x install-ubuntu.sh
	@./install-ubuntu.sh

# Start services
start:
	@echo "🚀 Starting Jasmin SMS Gateway services..."
	@chmod +x ubuntu-commands.sh
	@./ubuntu-commands.sh start

# Stop services
stop:
	@echo "🛑 Stopping Jasmin SMS Gateway services..."
	@chmod +x ubuntu-commands.sh
	@./ubuntu-commands.sh stop

# Restart services
restart:
	@echo "🔄 Restarting Jasmin SMS Gateway services..."
	@chmod +x ubuntu-commands.sh
	@./ubuntu-commands.sh restart

# Check status
status:
	@echo "🏥 Checking service status..."
	@chmod +x ubuntu-commands.sh
	@./ubuntu-commands.sh status

# Follow logs
logs:
	@echo "📄 Following Jasmin logs..."
	@chmod +x ubuntu-commands.sh
	@./ubuntu-commands.sh logs

# Test SMS sending
test:
	@echo "📱 Testing SMS sending..."
	@chmod +x ubuntu-commands.sh
	@./ubuntu-commands.sh test

# Connect to CLI
cli:
	@echo "🔧 Connecting to Management CLI..."
	@chmod +x ubuntu-commands.sh
	@./ubuntu-commands.sh cli

# Clean installation
clean:
	@echo "🧹 Cleaning up Jasmin SMS Gateway installation..."
	@sudo systemctl stop jasmind || true
	@sudo systemctl disable jasmind || true
	@sudo apt-get remove -y jasmin-sms-gateway || true
	@sudo apt-get autoremove -y || true
	@sudo rm -rf /etc/jasmin /var/log/jasmin || true
	@sudo userdel jasmin || true
	@echo "✅ Cleanup complete!"