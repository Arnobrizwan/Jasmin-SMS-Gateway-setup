#!/bin/bash
# Jasmin SMS Gateway - Ubuntu Installation Script
# Based on official Jasmin documentation

set -e

echo "🚀 Jasmin SMS Gateway - Ubuntu Installation"
echo "============================================="

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ This script should not be run as root for security reasons"
   echo "Please run as a regular user with sudo privileges"
   exit 1
fi

# Check Ubuntu version
if ! command -v lsb_release &> /dev/null; then
    echo "❌ lsb_release not found. Please install lsb-release:"
    echo "sudo apt-get install lsb-release"
    exit 1
fi

UBUNTU_VERSION=$(lsb_release -rs)
echo "📋 Detected Ubuntu version: $UBUNTU_VERSION"

if (( $(echo "$UBUNTU_VERSION < 20.04" | bc -l) )); then
    echo "❌ Ubuntu 20.04 or newer is required. You have $UBUNTU_VERSION"
    exit 1
fi

echo "✅ Ubuntu version is supported"

# Update system
echo "🔄 Updating system packages..."
sudo apt-get update

# Install dependencies
echo "📦 Installing dependencies..."
sudo apt-get install -y \
    rabbitmq-server \
    redis-server \
    python3 \
    python3-pip \
    python3-dev \
    libffi-dev \
    libssl-dev \
    python3-twisted \
    bc \
    curl \
    telnet

# Start and enable services
echo "🔧 Starting and enabling services..."
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server
sudo systemctl start redis-server
sudo systemctl enable redis-server

# Configure RabbitMQ
echo "🐰 Configuring RabbitMQ..."
sudo rabbitmq-plugins enable rabbitmq_management

# Generate secure password for RabbitMQ
RABBITMQ_PASSWORD=$(openssl rand -base64 32)
echo "🔐 Generated RabbitMQ password: $RABBITMQ_PASSWORD"

sudo rabbitmqctl add_user admin "$RABBITMQ_PASSWORD"
sudo rabbitmqctl set_user_tags admin administrator
sudo rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"

# Generate secure passwords for Jasmin
JASMIN_HTTP_PASSWORD=$(openssl rand -base64 32)
JASMIN_CLI_PASSWORD=$(openssl rand -base64 32)

echo "🔐 Generated Jasmin HTTP password: $JASMIN_HTTP_PASSWORD"
echo "🔐 Generated Jasmin CLI password: $JASMIN_CLI_PASSWORD"

# Install Jasmin
echo "📱 Installing Jasmin SMS Gateway..."
curl -s https://setup.jasminsms.com/deb | sudo bash
sudo apt-get install -y jasmin-sms-gateway

# Create system user and directories
echo "👤 Setting up system user and directories..."
sudo useradd -r -s /bin/false jasmin || echo "User jasmin already exists"
sudo mkdir -p /etc/jasmin/resource
sudo mkdir -p /etc/jasmin/store
sudo mkdir -p /var/log/jasmin
sudo chown -R jasmin:jasmin /etc/jasmin
sudo chown -R jasmin:jasmin /var/log/jasmin

# Create environment file with secure passwords
echo "🔐 Creating environment configuration..."
sudo tee /etc/jasmin/.env > /dev/null <<EOF
# Jasmin SMS Gateway Environment Variables
JASMIN_HTTP_USERNAME=jcliadmin
JASMIN_HTTP_PASSWORD=$JASMIN_HTTP_PASSWORD
JASMIN_CLI_USERNAME=jcliadmin
JASMIN_CLI_PASSWORD=$JASMIN_CLI_PASSWORD

# Redis Configuration
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_DB=0

# RabbitMQ Configuration
RABBITMQ_HOST=localhost
RABBITMQ_PORT=5672
RABBITMQ_USERNAME=admin
RABBITMQ_PASSWORD=$RABBITMQ_PASSWORD
RABBITMQ_VHOST=/

# Logging Configuration
JASMIN_LOG_LEVEL=INFO

# Performance Configuration
JASMIN_MAX_CONNECTIONS=1000
JASMIN_MAX_MPS=100
EOF

sudo chown jasmin:jasmin /etc/jasmin/.env
sudo chmod 600 /etc/jasmin/.env

# Start Jasmin service
echo "🚀 Starting Jasmin service..."
sudo systemctl enable jasmind
sudo systemctl start jasmind

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check service status
echo "🔍 Checking service status..."
echo "Redis status: $(sudo systemctl is-active redis-server)"
echo "RabbitMQ status: $(sudo systemctl is-active rabbitmq-server)"
echo "Jasmin status: $(sudo systemctl is-active jasmind)"

# Test connections
echo "🧪 Testing connections..."
redis-cli ping || echo "❌ Redis connection failed"
sudo rabbitmq-diagnostics ping || echo "❌ RabbitMQ connection failed"
curl -s http://localhost:1401/ping || echo "❌ Jasmin HTTP API not responding"

echo ""
echo "🎉 Installation complete!"
echo ""
echo "📱 Access your SMS gateway:"
echo "  HTTP API: http://localhost:1401"
echo "  Management CLI: telnet localhost 8990"
echo "  SMPP Server: localhost:2775"
echo "  RabbitMQ Management: http://localhost:15672"
echo ""
echo "🔐 IMPORTANT - Save these credentials:"
echo "  Jasmin HTTP API: jcliadmin / $JASMIN_HTTP_PASSWORD"
echo "  Jasmin Management CLI: jcliadmin / $JASMIN_CLI_PASSWORD"
echo "  RabbitMQ Management: admin / $RABBITMQ_PASSWORD"
echo ""
echo "⚠️  SECURITY WARNING:"
echo "  - Change all default passwords immediately"
echo "  - Credentials are saved in /etc/jasmin/.env"
echo "  - Keep this file secure and never commit it to version control"
echo ""
echo "🔧 Next steps:"
echo "  1. Connect to Management CLI: telnet localhost 8990"
echo "  2. Login with the credentials shown above"
echo "  3. Create users and routes as described in README.md"
echo "  4. Start sending SMS messages!"
echo ""
echo "📚 For more information, see README.md"
