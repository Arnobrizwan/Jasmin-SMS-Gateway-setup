#!/bin/bash
# Deploy Jasmin SMS Gateway to VNC Server
# Server: 203.18.158.5:5971

echo "🚀 Deploying Jasmin SMS Gateway to VNC Server..."
echo "📡 Server: 203.18.158.5:5971"
echo ""

# Check if we can connect to the server
echo "🔍 Checking server connection..."
if ! ping -c 1 203.18.158.5 > /dev/null 2>&1; then
    echo "❌ Cannot reach server 203.18.158.5"
    echo "Please check:"
    echo "  1. Server is running"
    echo "  2. Network connectivity"
    echo "  3. Firewall settings"
    exit 1
fi
echo "✅ Server is reachable"

# Create deployment package
echo "📦 Creating deployment package..."
tar -czf jasmin-deployment.tar.gz \
    --exclude='.git' \
    --exclude='logs' \
    --exclude='store' \
    --exclude='__pycache__' \
    --exclude='*.pyc' \
    .

echo "✅ Deployment package created: jasmin-deployment.tar.gz"

# Instructions for manual deployment
echo ""
echo "📋 DEPLOYMENT INSTRUCTIONS:"
echo "=========================="
echo ""
echo "1. Upload the deployment package to your server:"
echo "   scp jasmin-deployment.tar.gz user@203.18.158.5:/home/user/"
echo ""
echo "2. SSH into your server:"
echo "   ssh user@203.18.158.5"
echo ""
echo "3. Extract and setup on the server:"
echo "   cd /home/user"
echo "   tar -xzf jasmin-deployment.tar.gz"
echo "   cd jasmin-deployment"
echo "   chmod +x start.sh test.sh"
echo ""
echo "4. Install dependencies on the server:"
echo "   sudo apt-get update"
echo "   sudo apt-get install -y python3 python3-pip redis-server rabbitmq-server"
echo "   pip3 install --pre jasmin py4web"
echo ""
echo "5. Start services on the server:"
echo "   sudo systemctl start redis-server"
echo "   sudo systemctl start rabbitmq-server"
echo "   ./start.sh"
echo ""
echo "6. Test the deployment:"
echo "   ./test.sh"
echo ""
echo "🌐 After deployment, access:"
echo "   - SMS Gateway API: http://203.18.158.5:1401"
echo "   - Py4Web GUI: http://203.18.158.5:8000/jasmin_smsc_gui"
echo "   - Management CLI: telnet 203.18.158.5:8990"
echo ""
echo "🔧 Server Configuration:"
echo "   - Make sure ports 1401, 8000, 8990 are open in firewall"
echo "   - Update jasmin.cfg if needed for server IP"
echo "   - Check server logs in ./logs/ directory"
echo ""
echo "✅ Deployment package ready!"
