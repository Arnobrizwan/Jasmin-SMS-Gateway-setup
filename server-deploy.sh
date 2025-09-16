#!/bin/bash
# Server deployment script

echo "🚀 Deploying Jasmin SMS Gateway..."

# Install dependencies
apt-get update -y
apt-get install -y python3 python3-pip redis-server rabbitmq-server

# Install Python packages
pip3 install --pre jasmin py4web

# Start services
systemctl enable redis-server rabbitmq-server
systemctl start redis-server rabbitmq-server

# Create directories
mkdir -p logs store apps/jasmin_smsc_gui/uploads

# Set permissions
chmod +x *.sh

# Configure firewall
ufw allow 1401/tcp
ufw allow 8000/tcp
ufw allow 8990/tcp
ufw allow 2775/tcp

echo "✅ Deployment complete!"
echo "🚀 Starting system..."
./start-server.sh
