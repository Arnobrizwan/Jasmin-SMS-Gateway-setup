#!/bin/bash
# Jasmin SMS Gateway - Complete Server Installation Script
# This script installs and configures Jasmin on Ubuntu server

set -e

echo "🚀 Installing Jasmin SMS Gateway on Ubuntu Server"
echo "================================================"

# Update system
echo "📦 Updating system packages..."
apt-get update
apt-get upgrade -y

# Install required dependencies
echo "📦 Installing dependencies..."
apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    libffi-dev \
    libssl-dev \
    python3-twisted \
    redis-server \
    rabbitmq-server \
    curl \
    wget \
    git \
    htop \
    net-tools

# Start and enable services
echo "🔧 Starting and enabling services..."
systemctl start redis-server
systemctl enable redis-server
systemctl start rabbitmq-server
systemctl enable rabbitmq-server

# Configure RabbitMQ
echo "🐰 Configuring RabbitMQ..."
rabbitmq-plugins enable rabbitmq_management
rabbitmqctl add_user admin admin123
rabbitmqctl set_user_tags admin administrator
rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"

# Create jasmin user and directories
echo "👤 Creating system user and directories..."
useradd -r -s /bin/false jasmin || true
mkdir -p /etc/jasmin /etc/jasmin/resource /etc/jasmin/store /var/log/jasmin
chown -R jasmin:jasmin /etc/jasmin /var/log/jasmin

# Install Jasmin
echo "📱 Installing Jasmin SMS Gateway..."
pip3 install jasmin

# Create Jasmin configuration
echo "📋 Creating Jasmin configuration..."
cat > /etc/jasmin/jasmin.cfg << 'EOF'
# Jasmin SMS Gateway Configuration for Production Server

# HTTP API Configuration
[http-api]
bind = 0.0.0.0
port = 1401
username = jcliadmin
password = jclipwd
long_content_max_parts = 5
long_content_split = udh
access_log = /var/log/jasmin/http-access.log
log_level = INFO
log_file = /var/log/jasmin/http-api.log
log_format = %(asctime)s %(levelname)-8s %(process)d %(message)s
log_date_format = %Y-%m-%d %H:%M:%S

# Management CLI Configuration
[jcli]
bind = 0.0.0.0
port = 8990
username = jcliadmin
password = jclipwd
log_level = INFO
log_file = /var/log/jasmin/jcli.log
log_format = %(asctime)s %(levelname)-8s %(process)d %(message)s
log_date_format = %Y-%m-%d %H:%M:%S

# SMPP Server Configuration
[smpp-server]
id = "smpps_01"
bind = 0.0.0.0
port = 2775
sessionInitTimerSecs = 30
enquireLinkTimerSecs = 30
inactivityTimerSecs = 300
responseTimerSecs = 60
pduReadTimerSecs = 30
log_level = INFO
log_file = /var/log/jasmin/smpp-server.log
log_format = %(asctime)s %(levelname)-8s %(process)d %(message)s
log_date_format = %Y-%m-%d %H:%M:%S

# Redis Configuration
[redis-client]
host = localhost
port = 6379
db = 0

# RabbitMQ Configuration
[amqp-broker]
host = localhost
port = 5672
username = admin
password = admin123
vhost = /

# Logging Configuration
[logging]
level = INFO
file = /var/log/jasmin/jasmin.log
format = %(asctime)s %(levelname)-8s %(process)d %(message)s
date_format = %Y-%m-%d %H:%M:%S

# Performance Configuration
[performance]
max-connections = 1000
max-messages-per-second = 100

# DLR Thrower Configuration
[dlr-thrower]
http_timeout = 30
retry_delay = 30
max_retries = 3
log_level = INFO
log_file = /var/log/jasmin/dlr-thrower.log
log_format = %(asctime)s %(levelname)-8s %(process)d %(message)s
log_date_format = %Y-%m-%d %H:%M:%S

# DeliverSM Thrower Configuration
[deliversm-thrower]
http_timeout = 30
retry_delay = 30
max_retries = 3
log_level = INFO
log_file = /var/log/jasmin/deliversm-thrower.log
log_format = %(asctime)s %(levelname)-8s %(process)d %(message)s
log_date_format = %Y-%m-%d %H:%M:%S

# Router Configuration
[router]
log_level = INFO
log_file = /var/log/jasmin/router.log
log_format = %(asctime)s %(levelname)-8s %(process)d %(message)s
log_date_format = %Y-%m-%d %H:%M:%S

# SMPP Client Manager Configuration
[smpp-client-manager]
log_level = INFO
log_file = /var/log/jasmin/smpp-client-manager.log
log_format = %(asctime)s %(levelname)-8s %(process)d %(message)s
log_date_format = %Y-%m-%d %H:%M:%S

# Interceptor Configuration
[interceptor]
log_level = INFO
log_file = /var/log/jasmin/interceptor.log
log_format = %(asctime)s %(levelname)-8s %(process)d %(message)s
log_date_format = %Y-%m-%d %H:%M:%S
EOF

chown jasmin:jasmin /etc/jasmin/jasmin.cfg

# Create systemd service
echo "🔧 Creating systemd service..."
cat > /etc/systemd/system/jasmind.service << 'EOF'
[Unit]
Description=Jasmin SMS Gateway
After=network.target redis.service rabbitmq-server.service
Requires=redis.service rabbitmq-server.service

[Service]
Type=simple
User=jasmin
Group=jasmin
WorkingDirectory=/etc/jasmin
ExecStart=/usr/local/bin/jasmind -c /etc/jasmin/jasmin.cfg
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Enable and start service
echo "🚀 Starting Jasmin service..."
systemctl daemon-reload
systemctl enable jasmind
systemctl start jasmind

# Wait for service to start
echo "⏳ Waiting for service to start..."
sleep 15

# Test the installation
echo "🧪 Testing installation..."

# Check if service is running
if systemctl is-active --quiet jasmind; then
    echo "✅ Jasmin service is running"
else
    echo "❌ Jasmin service failed to start"
    echo "Checking service status:"
    systemctl status jasmind --no-pager
    exit 1
fi

# Test HTTP API
if curl -s http://localhost:1401/ping | grep -q "Jasmin/PONG"; then
    echo "✅ HTTP API is responding"
else
    echo "❌ HTTP API is not responding"
    echo "Checking HTTP API logs:"
    tail -20 /var/log/jasmin/http-api.log || echo "No HTTP API logs found"
fi

# Test Management CLI
if timeout 5 bash -c "echo > /dev/tcp/localhost/8990" 2>/dev/null; then
    echo "✅ Management CLI is accessible"
else
    echo "❌ Management CLI is not accessible"
fi

# Test SMPP Server
if timeout 5 bash -c "echo > /dev/tcp/localhost/2775" 2>/dev/null; then
    echo "✅ SMPP Server is accessible"
else
    echo "❌ SMPP Server is not accessible"
fi

echo ""
echo "🎉 Installation complete!"
echo ""
echo "📱 Access your SMS gateway:"
echo "  HTTP API: http://$(hostname -I | awk '{print $1}'):1401"
echo "  Management CLI: telnet $(hostname -I | awk '{print $1}') 8990"
echo "  SMPP Server: $(hostname -I | awk '{print $1}'):2775"
echo "  RabbitMQ Management: http://$(hostname -I | awk '{print $1}'):15672"
echo ""
echo "🔐 Default credentials:"
echo "  Username: jcliadmin"
echo "  Password: jclipwd"
echo ""
echo "📋 Management commands:"
echo "  Check status: systemctl status jasmind"
echo "  View logs: journalctl -u jasmind -f"
echo "  Restart: systemctl restart jasmind"
echo "  Stop: systemctl stop jasmind"
echo "  Start: systemctl start jasmind"
echo ""
echo "📁 Log files location:"
echo "  Main log: /var/log/jasmin/jasmin.log"
echo "  HTTP API: /var/log/jasmin/http-api.log"
echo "  Management CLI: /var/log/jasmin/jcli.log"
echo "  SMPP Server: /var/log/jasmin/smpp-server.log"
