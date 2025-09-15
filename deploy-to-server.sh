#!/bin/bash
# Jasmin SMS Gateway - Remote Server Deployment Script
# This script deploys Jasmin to the remote Ubuntu server

set -e

# Server configuration
SERVER_IP="203.18.159.132"
SERVER_USER="root"
SERVER_PASSWORD="passkomuna"

echo "🚀 Deploying Jasmin SMS Gateway to remote server..."
echo "Server: $SERVER_IP"
echo "=================================================="

# Function to run commands on remote server
run_remote() {
    sshpass -p "$SERVER_PASSWORD" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_IP" "$@"
}

# Function to copy files to remote server
copy_to_remote() {
    local local_file=$1
    local remote_path=$2
    sshpass -p "$SERVER_PASSWORD" scp -o StrictHostKeyChecking=no "$local_file" "$SERVER_USER@$SERVER_IP:$remote_path"
}

echo "📦 Installing dependencies on remote server..."

# Update system and install dependencies
run_remote "apt-get update && apt-get install -y python3 python3-pip redis-server rabbitmq-server python3-dev libffi-dev libssl-dev python3-twisted"

echo "🔧 Configuring services..."

# Start and enable services
run_remote "systemctl start redis-server && systemctl enable redis-server"
run_remote "systemctl start rabbitmq-server && systemctl enable rabbitmq-server"

# Configure RabbitMQ
run_remote "rabbitmq-plugins enable rabbitmq_management"
run_remote "rabbitmqctl add_user admin admin123"
run_remote "rabbitmqctl set_user_tags admin administrator"
run_remote "rabbitmqctl set_permissions -p / admin '.*' '.*' '.*'"

echo "📱 Installing Jasmin SMS Gateway..."

# Install Jasmin
run_remote "pip3 install jasmin"

# Create system user and directories
run_remote "useradd -r -s /bin/false jasmin || true"
run_remote "mkdir -p /etc/jasmin /etc/jasmin/resource /etc/jasmin/store /var/log/jasmin"
run_remote "chown -R jasmin:jasmin /etc/jasmin /var/log/jasmin"

echo "📋 Creating configuration files..."

# Create Jasmin configuration for server
cat > jasmin-server.cfg << 'EOF'
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

# Copy configuration to server
copy_to_remote "jasmin-server.cfg" "/etc/jasmin/jasmin.cfg"
run_remote "chown jasmin:jasmin /etc/jasmin/jasmin.cfg"

echo "🔧 Creating systemd service..."

# Create systemd service file
cat > jasmind.service << 'EOF'
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

[Install]
WantedBy=multi-user.target
EOF

# Copy service file to server
copy_to_remote "jasmind.service" "/etc/systemd/system/jasmind.service"

echo "🚀 Starting Jasmin service..."

# Enable and start service
run_remote "systemctl daemon-reload"
run_remote "systemctl enable jasmind"
run_remote "systemctl start jasmind"

echo "⏳ Waiting for service to start..."
sleep 10

echo "🧪 Testing deployment..."

# Test if services are running
if run_remote "systemctl is-active --quiet jasmind"; then
    echo "✅ Jasmin service is running"
else
    echo "❌ Jasmin service failed to start"
    run_remote "systemctl status jasmind"
    exit 1
fi

# Test HTTP API
if run_remote "curl -s http://localhost:1401/ping | grep -q 'Jasmin/PONG'"; then
    echo "✅ HTTP API is responding"
else
    echo "❌ HTTP API is not responding"
fi

echo ""
echo "🎉 Deployment complete!"
echo ""
echo "📱 Access your SMS gateway:"
echo "  HTTP API: http://$SERVER_IP:1401"
echo "  Management CLI: telnet $SERVER_IP 8990"
echo "  SMPP Server: $SERVER_IP:2775"
echo "  RabbitMQ Management: http://$SERVER_IP:15672"
echo ""
echo "🔐 Default credentials:"
echo "  Username: jcliadmin"
echo "  Password: jclipwd"
echo ""
echo "📋 Management commands:"
echo "  Check status: ssh $SERVER_USER@$SERVER_IP 'systemctl status jasmind'"
echo "  View logs: ssh $SERVER_USER@$SERVER_IP 'journalctl -u jasmind -f'"
echo "  Restart: ssh $SERVER_USER@$SERVER_IP 'systemctl restart jasmind'"
