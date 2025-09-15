#!/bin/bash
# Simple deployment script for Jasmin SMS Gateway
# This script copies the installation script to the server and runs it

set -e

# Server configuration
SERVER_IP="203.18.159.132"
SERVER_USER="root"
SERVER_PASSWORD="passkomuna"

echo "🚀 Deploying Jasmin SMS Gateway to server..."
echo "Server: $SERVER_IP"
echo "============================================="

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

echo "📦 Copying installation script to server..."
copy_to_remote "install-jasmin-server.sh" "/tmp/install-jasmin-server.sh"

echo "🔧 Making script executable on server..."
run_remote "chmod +x /tmp/install-jasmin-server.sh"

echo "🚀 Running installation on server..."
run_remote "/tmp/install-jasmin-server.sh"

echo ""
echo "🎉 Deployment complete!"
echo ""
echo "📱 Your Jasmin SMS Gateway is now running at:"
echo "  HTTP API: http://$SERVER_IP:1401"
echo "  Management CLI: telnet $SERVER_IP 8990"
echo "  SMPP Server: $SERVER_IP:2775"
echo "  RabbitMQ Management: http://$SERVER_IP:15672"
echo ""
echo "🔐 Default credentials:"
echo "  Username: jcliadmin"
echo "  Password: jclipwd"
echo ""
echo "📋 To manage your server:"
echo "  SSH: ssh $SERVER_USER@$SERVER_IP"
echo "  Check status: systemctl status jasmind"
echo "  View logs: journalctl -u jasmind -f"
