#!/bin/bash
# Jasmin SMS Gateway - Server Deployment Template
# Update the variables below with your server details

set -e

# =============================================================================
# CONFIGURATION - UPDATE THESE VALUES
# =============================================================================
SERVER_IP="YOUR_SERVER_IP_HERE"
USERNAME="YOUR_USERNAME_HERE"
PASSWORD="YOUR_PASSWORD_HERE"

# =============================================================================
# DEPLOYMENT SCRIPT
# =============================================================================

echo "🚀 Deploying Jasmin SMS Gateway to $USERNAME@$SERVER_IP..."
echo "=================================================="

# Validate configuration
if [ "$SERVER_IP" = "YOUR_SERVER_IP_HERE" ] || [ "$USERNAME" = "YOUR_USERNAME_HERE" ] || [ "$PASSWORD" = "YOUR_PASSWORD_HERE" ]; then
    echo "❌ Please update the configuration variables at the top of this script!"
    echo "   - SERVER_IP: Your server's IP address"
    echo "   - USERNAME: Your server username"
    echo "   - PASSWORD: Your server password"
    exit 1
fi

# Check server reachability
echo "🔍 Checking server connectivity..."
ping -c 3 "$SERVER_IP"
if [ $? -ne 0 ]; then
    echo "❌ Server $SERVER_IP is unreachable. Please ensure the server is online and accessible."
    exit 1
fi

echo "✅ Server is reachable!"

# Create deployment package
echo "📦 Creating deployment package..."
DEPLOY_DIR="jasmin-deploy-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$DEPLOY_DIR"

# Copy all necessary files
cp install-jasmin-server.sh "$DEPLOY_DIR/"
cp jasmin-fixed.cfg "$DEPLOY_DIR/jasmin-server.cfg"
cp etc/resource/amqp0-9-1.xml "$DEPLOY_DIR/"
cp jasmin-web-panel.py "$DEPLOY_DIR/"

# Create a comprehensive server configuration
cat > "$DEPLOY_DIR/jasmin-server-final.cfg" << 'EOF'
# Jasmin SMS Gateway - Server Configuration
# This configuration is optimized for production server deployment

# HTTP API Configuration
[http-api]
bind = 0.0.0.0
port = 1401
username = jcliadmin
password = jclipwd

# Management CLI Configuration
[jcli]
bind = 0.0.0.0
port = 8990
username = jcliadmin
password = jclipwd

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
log_file = /var/log/jasmin/smpp.log
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
spec = /etc/jasmin/resource/amqp0-9-1.xml

# Logging Configuration
[logging]
level = INFO
file = /var/log/jasmin/jasmin.log

# Performance Configuration
[performance]
max-connections = 1000
max-messages-per-second = 100
EOF

# Create web panel startup script
cat > "$DEPLOY_DIR/start-web-panel.sh" << 'EOF'
#!/bin/bash
# Start Jasmin Web Panel

cd /opt/jasmin
python3 jasmin-web-panel.py &
echo "Web panel started on http://$(hostname -I | awk '{print $1}'):5000"
EOF

chmod +x "$DEPLOY_DIR/start-web-panel.sh"

# Create systemd service for web panel
cat > "$DEPLOY_DIR/jasmin-web-panel.service" << 'EOF'
[Unit]
Description=Jasmin SMS Gateway Web Panel
After=network.target jasmind.service
Requires=jasmind.service

[Service]
Type=simple
User=jasmin
Group=jasmin
WorkingDirectory=/opt/jasmin
ExecStart=/usr/bin/python3 /opt/jasmin/jasmin-web-panel.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Create final deployment script
cat > "$DEPLOY_DIR/deploy-final.sh" << 'EOF'
#!/bin/bash
# Final deployment script to run on the server

set -e

echo "🚀 Finalizing Jasmin SMS Gateway installation..."

# Install Python dependencies for web panel
apt-get update
apt-get install -y python3-flask python3-requests

# Copy web panel files
cp jasmin-web-panel.py /opt/jasmin/
cp start-web-panel.sh /opt/jasmin/
chmod +x /opt/jasmin/start-web-panel.sh

# Copy final configuration
cp jasmin-server-final.cfg /etc/jasmin/jasmin.cfg
chown jasmin:jasmin /etc/jasmin/jasmin.cfg

# Copy AMQP spec file
cp amqp0-9-1.xml /etc/jasmin/resource/
chown jasmin:jasmin /etc/jasmin/resource/amqp0-9-1.xml

# Install web panel systemd service
cp jasmin-web-panel.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable jasmin-web-panel
systemctl start jasmin-web-panel

# Restart Jasmin with new configuration
systemctl restart jasmind

echo "✅ Deployment completed!"
echo ""
echo "📱 Access your SMS gateway:"
echo "  HTTP API: http://$(hostname -I | awk '{print $1}'):1401"
echo "  Web Panel: http://$(hostname -I | awk '{print $1}'):5000"
echo "  Management CLI: telnet $(hostname -I | awk '{print $1}') 8990"
echo "  SMPP Server: $(hostname -I | awk '{print $1}'):2775"
echo ""
echo "🔐 Default credentials:"
echo "  Username: jcliadmin"
echo "  Password: jclipwd"
EOF

chmod +x "$DEPLOY_DIR/deploy-final.sh"

echo "📦 Deployment package created: $DEPLOY_DIR"

# Copy deployment package to server
echo "📂 Copying deployment package to remote server..."
sshpass -p "$PASSWORD" scp -o StrictHostKeyChecking=no -r "$DEPLOY_DIR" "$USERNAME@$SERVER_IP:/tmp/"

# Run the installation script on the remote server
echo "⚙️  Running installation script on remote server..."
sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$USERNAME@$SERVER_IP" << EOF
cd /tmp/$DEPLOY_DIR
chmod +x *.sh
sudo bash install-jasmin-server.sh
sudo bash deploy-final.sh
EOF

echo ""
echo "🎉 Deployment completed successfully!"
echo ""
echo "📱 Your Jasmin SMS Gateway is now running on:"
echo "  Server IP: $SERVER_IP"
echo "  HTTP API: http://$SERVER_IP:1401"
echo "  Web Panel: http://$SERVER_IP:5000"
echo "  Management CLI: telnet $SERVER_IP 8990"
echo "  SMPP Server: $SERVER_IP:2775"
echo ""
echo "🔐 Default credentials:"
echo "  Username: jcliadmin"
echo "  Password: jclipwd"
echo ""
echo "🧪 Test your deployment:"
echo "  curl http://$SERVER_IP:1401/ping"
echo "  curl http://$SERVER_IP:5000"
