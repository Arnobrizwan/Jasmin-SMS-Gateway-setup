#!/bin/bash
# Clean Jasmin SMS Gateway Deployment
# Server: 203.18.158.5

echo "🚀 Creating Clean Deployment Package"
echo "===================================="

# Create deployment package
echo "📦 Creating package..."
rm -f jasmin-deployment.tar.gz
tar -czf jasmin-deployment.tar.gz \
    --exclude='.git' \
    --exclude='logs' \
    --exclude='store' \
    --exclude='__pycache__' \
    --exclude='*.pyc' \
    --exclude='jasmin-deployment.tar.gz' \
    .

echo "✅ Package created: jasmin-deployment.tar.gz"
echo "📊 Size: $(du -h jasmin-deployment.tar.gz | cut -f1)"

# Create server deployment script
cat > server-deploy.sh << 'EOF'
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
EOF

echo ""
echo "🎯 DEPLOYMENT STEPS:"
echo "==================="
echo "1. Upload: scp jasmin-deployment.tar.gz root@203.18.158.5:/root/"
echo "2. SSH: ssh root@203.18.158.5"
echo "3. Deploy: tar -xzf jasmin-deployment.tar.gz && cd jasmin-deployment && chmod +x server-deploy.sh && ./server-deploy.sh"
echo ""
echo "🌐 Access URLs:"
echo "   - SMS API: http://203.18.158.5:1401"
echo "   - Py4Web GUI: http://203.18.158.5:8000/jasmin_smsc_gui"
echo "   - Management CLI: telnet 203.18.158.5:8990"
echo ""
echo "✅ Ready to deploy!"
