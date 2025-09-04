#!/bin/bash
# Google Cloud Platform Deployment Script for Jasmin SMS Gateway

set -e

echo "☁️  Jasmin SMS Gateway - Google Cloud Deployment"
echo "================================================"

# Check if running on Ubuntu
if ! command -v lsb_release &> /dev/null; then
    echo "❌ This script requires Ubuntu. Installing lsb-release..."
    sudo apt-get update
    sudo apt-get install -y lsb-release
fi

UBUNTU_VERSION=$(lsb_release -rs)
echo "📋 Deploying on Ubuntu $UBUNTU_VERSION"

# Check Ubuntu version compatibility
if (( $(echo "$UBUNTU_VERSION < 20.04" | bc -l) )); then
    echo "❌ Ubuntu 20.04 or newer is required. You have $UBUNTU_VERSION"
    exit 1
fi

echo "✅ Ubuntu version is supported"

# Update system
echo "🔄 Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install essential packages
echo "📦 Installing essential packages..."
sudo apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    htop \
    ufw \
    fail2ban \
    bc \
    openssl

# Clone repository if not already present
if [ ! -d "jasmin-docker" ]; then
    echo "📥 Cloning repository..."
    git clone https://github.com/Arnobrizwan/Jasmin-SMS-Gateway-setup.git
    cd jasmin-docker
else
    echo "✅ Repository already exists"
    cd jasmin-docker
fi

# Make scripts executable
echo "🔧 Setting up scripts..."
chmod +x *.sh
chmod +x ubuntu-commands.sh

# Run pre-installation test
echo "🧪 Running pre-installation test..."
./test-real-ubuntu.sh

# Install Jasmin SMS Gateway
echo "🚀 Installing Jasmin SMS Gateway..."
./install-ubuntu.sh

# Configure firewall
echo "🔥 Configuring firewall..."
sudo ufw --force enable
sudo ufw allow ssh
sudo ufw allow 1401/tcp  # HTTP API
sudo ufw allow 8990/tcp  # Management CLI
sudo ufw allow 2775/tcp  # SMPP Server
sudo ufw allow 15672/tcp # RabbitMQ Management
sudo ufw reload

# Configure fail2ban
echo "🛡️  Configuring fail2ban..."
sudo tee /etc/fail2ban/jail.d/jasmin.conf > /dev/null <<EOF
[jasmin-http]
enabled = true
port = 1401
filter = jasmin-http
logpath = /var/log/jasmin/messages.log
maxretry = 5
bantime = 3600

[jasmin-cli]
enabled = true
port = 8990
filter = jasmin-cli
logpath = /var/log/jasmin/jasmin.log
maxretry = 3
bantime = 7200
EOF

sudo systemctl restart fail2ban
sudo systemctl enable fail2ban

# Get server IP
SERVER_IP=$(curl -s ifconfig.me || curl -s ipinfo.io/ip || hostname -I | awk '{print $1}')

echo ""
echo "🎉 Google Cloud deployment complete!"
echo ""
echo "📱 Access your SMS gateway:"
echo "  HTTP API: http://$SERVER_IP:1401"
echo "  Management CLI: telnet $SERVER_IP 8990"
echo "  SMPP Server: $SERVER_IP:2775"
echo "  RabbitMQ Management: http://$SERVER_IP:15672"
echo ""
echo "🔐 IMPORTANT - Save these credentials:"
echo "  Check /etc/jasmin/.env for generated passwords"
echo ""
echo "🔧 Management commands:"
echo "  make status    - Check service status"
echo "  make logs      - View logs"
echo "  make cli       - Connect to Management CLI"
echo "  make test      - Test SMS sending"
echo ""
echo "🛡️  Security features enabled:"
echo "  ✅ Firewall configured"
echo "  ✅ Fail2ban enabled"
echo "  ✅ Secure passwords generated"
echo ""
echo "📚 Documentation:"
echo "  README.md - Complete usage guide"
echo "  SECURITY.md - Security best practices"
