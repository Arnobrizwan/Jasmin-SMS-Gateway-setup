# Jasmin SMS Gateway - Complete Setup Guide

## 🚀 **Overview**

This repository contains a complete setup for the Jasmin SMS Gateway, including installation scripts, configuration files, and a web-based monitoring dashboard. The setup supports both local development and production deployment on cloud platforms.

### 📋 **Features**
- ✅ **Complete Installation Scripts** for Ubuntu/Debian
- ✅ **Web Dashboard** with real-time monitoring
- ✅ **CORS Proxy** for seamless remote access
- ✅ **Docker Support** for containerized deployment
- ✅ **Security Best Practices** implemented
- ✅ **Comprehensive Documentation** and examples
- ✅ **Production Ready** configuration

### 🎯 **Supported Platforms**
- **Ubuntu 20.04+** (Primary)
- **Ubuntu 18.04** (Limited)
- **Debian 10+** (Compatible)
- **Docker** (All platforms)
- **Cloud VMs** (AWS, GCP, Azure, etc.)

## 🚀 **Quick Start**

### **1. Clone the Repository**
```bash
git clone https://github.com/Arnobrizwan/Jasmin-SMS-Gateway-setup.git
cd Jasmin-SMS-Gateway-setup/jasmin-docker
```

### **2. Choose Your Installation Method**

#### **Option A: Ubuntu/Debian Package (Recommended)**
```bash
# Run the installation script
chmod +x install-ubuntu.sh
sudo ./install-ubuntu.sh
```

#### **Option B: Docker (Production Ready)**
```bash
# Start with Docker Compose
docker-compose up -d
```

#### **Option C: Manual Installation**
```bash
# Follow the detailed installation guide
./quick-deploy.sh
```

### **3. Start the Dashboard**
```bash
# Start the monitoring dashboard
python3 cors-proxy.py 8081
# Open http://localhost:8081/dashboard.html
```

### **4. Test Your Installation**
```bash
# Test ping
curl "http://localhost:1401/ping"

# Test status
curl "http://localhost:1401/status"

# Send test SMS (after configuring users)
curl "http://localhost:1401/send?username=YOUR_USER&password=YOUR_PASS&to=+1234567890&content=Hello%20World"
```

## 📱 **API Endpoints**

### **HTTP API (Port 1401)**
- **Send SMS**: `GET /send?username=USER&password=PASSWORD&to=PHONE&content=MESSAGE`
- **Status**: `GET /status`
- **Ping**: `GET /ping`
- **Metrics**: `GET /metrics` (Prometheus format)

### **Example Response**
```json
{
  "status": "success",
  "message_id": "unique-message-id-uuid",
  "to": "1234567890",
  "content": "Hello World",
  "timestamp": "2025-09-04T10:29:10.991167"
}
```

### **Error Response**
```json
{
  "status": "error",
  "message": "Error description"
}
```

## 🌐 **Network Access**

### **Local Development**
- **HTTP API**: `http://localhost:1401`
- **Management CLI**: `telnet localhost 8990`
- **Dashboard**: `http://localhost:8081/dashboard.html`

### **Production Deployment**
- **HTTP API**: `http://YOUR_SERVER_IP:1401`
- **Management CLI**: `telnet YOUR_SERVER_IP 8990`
- **Dashboard**: `http://YOUR_SERVER_IP:8081/dashboard.html`

## 📋 **Integration Examples**

### **Python Integration**
```python
import requests
import os

def send_sms(phone_number, message, server_url="http://localhost:1401"):
    """Send SMS via HTTP API"""
    url = f"{server_url}/send"
    params = {
        'username': os.getenv('SMS_USERNAME', 'your_username'),
        'password': os.getenv('SMS_PASSWORD', 'your_password'),
        'to': phone_number,
        'content': message
    }
    response = requests.get(url, params=params)
    return response.json()

# Example usage
result = send_sms("+1234567890", "Hello from Python!")
print(result)
```

### **JavaScript Integration**
```javascript
async function sendSMS(phoneNumber, message, serverUrl = 'http://localhost:1401') {
    const url = `${serverUrl}/send`;
    const params = new URLSearchParams({
        username: process.env.SMS_USERNAME || 'your_username',
        password: process.env.SMS_PASSWORD || 'your_password',
        to: phoneNumber,
        content: message
    });
    
    const response = await fetch(`${url}?${params}`);
    return await response.json();
}

// Example usage
sendSMS('+1234567890', 'Hello from JavaScript!')
    .then(result => console.log(result));
```

### **cURL Integration**
```bash
#!/bin/bash
# send_sms.sh

PHONE_NUMBER=$1
MESSAGE=$2
SERVER_URL=${3:-"http://localhost:1401"}
USERNAME=${SMS_USERNAME:-"your_username"}
PASSWORD=${SMS_PASSWORD:-"your_password"}

if [ -z "$PHONE_NUMBER" ] || [ -z "$MESSAGE" ]; then
    echo "Usage: $0 <phone_number> <message> [server_url]"
    exit 1
fi

curl "${SERVER_URL}/send?username=${USERNAME}&password=${PASSWORD}&to=${PHONE_NUMBER}&content=${MESSAGE}"
```

### **Environment Variables Setup**
```bash
# Set environment variables for secure credential management
export SMS_USERNAME="your_username"
export SMS_PASSWORD="your_secure_password"
export SMS_SERVER_URL="http://your-server:1401"
```

## 📊 **Monitoring Dashboard**

### **Web Dashboard**
A beautiful, real-time dashboard is included to monitor your SMS Gateway with CORS proxy support:

```bash
# Start the dashboard with CORS proxy (Recommended)
python3 cors-proxy.py 8081

# Or use the original startup script (requires CORS workaround)
./start-dashboard.sh
```

**Dashboard Features:**
- ✅ **Real-time monitoring** of API calls
- ✅ **Gateway status** (Online/Offline)
- ✅ **API health checks** with response times
- ✅ **Authentication testing**
- ✅ **SMS sending interface**
- ✅ **Activity logs** with timestamps
- ✅ **Statistics** (total calls, success/error counts)
- ✅ **Uptime tracking**
- ✅ **Auto-refresh** every 30 seconds
- ✅ **CORS proxy** for seamless remote gateway access

**Access Dashboard:**
- **URL**: `http://localhost:8081/dashboard.html`
- **Auto-opens** in your browser
- **Perfect for testing** and monitoring
- **Works with remote SMS Gateway** via CORS proxy

### **CORS Proxy Setup**
The dashboard includes a CORS proxy (`cors-proxy.py`) that allows the local dashboard to communicate with the remote SMS Gateway without browser security restrictions.

**How it works:**
1. Dashboard runs on `localhost:8081`
2. CORS proxy forwards requests to `34.56.36.182:1401`
3. Browser can make requests to same-origin (localhost) without CORS issues
4. Proxy handles all authentication and response forwarding

## 🔧 **Service Management**

### **Check Service Status**
```bash
sudo systemctl status sms-gateway
```

### **View Logs**
```bash
sudo journalctl -u sms-gateway -f
sudo tail -f /var/log/jasmin/sms-gateway.log
```

### **Restart Service**
```bash
sudo systemctl restart sms-gateway
```

### **Stop Service**
```bash
sudo systemctl stop sms-gateway
```

## 📖 Usage

### 1. Send Your First SMS

#### Via HTTP API
```bash
curl "http://localhost:1401/send?username=foo&password=bar&to=1234567890&content=Hello World"
```

#### Via Management CLI

**Connect to CLI**
```bash
# Option 1: Using telnet
telnet localhost 8990

# Option 2: Using make command
make cli
```

**Login (default: jcliadmin/jclipwd)**
```
Username: jcliadmin
Password: jclipwd
```

**Create a Group:**
```
group -a
> gid default
> ok
```

**Create a User:**
```
user -a
> username foo
> password bar
> gid default
> uid foo
> ok
```

**Create a Route:**
```
mtrouter -a
> type defaultroute
> connector smppc(DEMO_CONNECTOR)
> rate 0.00
> ok
```

### 2. Configure SMPP Connection

```bash
# Connect to CLI
telnet localhost 8990

# Add SMPP connector
smppccm -a
> cid DEMO_CONNECTOR
> host 172.16.10.67
> port 2775
> username smppclient1
> password password
> submit_throughput 110
> ok

# Start connector
smppccm -1 DEMO_CONNECTOR
```

### 3. Monitor Your Gateway

#### Check Status
```bash
# Check service status
make status

# View logs
make logs

# Test SMS
make test
```

#### RabbitMQ Management
- Open http://localhost:15672
- Login: admin/admin
- Monitor queues, connections, and performance

## 🐧 Ubuntu Commands

### Basic Operations
```bash
# Start services
make start

# Stop services
make stop

# Restart services
make restart

# Check status
make status

# View logs
make logs

# Test SMS
make test

# Connect to CLI
make cli
```

### Service Management
```bash
# Check individual services
sudo systemctl status jasmind
sudo systemctl status rabbitmq-server
sudo systemctl status redis-server

# View logs
sudo journalctl -u jasmind -f
sudo journalctl -u rabbitmq-server -f
sudo journalctl -u redis-server -f

# Restart individual services
sudo systemctl restart jasmind
sudo systemctl restart rabbitmq-server
sudo systemctl restart redis-server
```

### Maintenance
```bash
# Update system
sudo apt update && sudo apt upgrade

# Update Jasmin
sudo apt update
sudo apt install jasmin-sms-gateway

# Clean installation
make clean
```

## 🔒 Security

### Default Credentials
- **Management CLI**: jcliadmin/[GENERATED_PASSWORD]
- **RabbitMQ Management**: admin/[GENERATED_PASSWORD]
- **Credentials are generated during installation and saved in /etc/jasmin/.env**

### Security Recommendations
1. **Change default passwords** immediately after installation
2. **Secure the .env file**: `/etc/jasmin/.env` contains sensitive credentials
3. **Configure firewall** rules to restrict access
4. **Use HTTPS** in production environments
5. **Regular updates** of system packages
6. **Monitor logs** regularly for suspicious activity
7. **Never commit** the .env file to version control
8. **Use strong passwords** for all services
9. **Enable fail2ban** for additional security
10. **Regular security audits** of the system

## 📊 Monitoring

### Health Checks
All services include health checks:
- **Redis**: `redis-cli ping`
- **RabbitMQ**: `sudo rabbitmq-diagnostics ping`
- **Jasmin**: HTTP endpoint check

### Logs
- **Jasmin**: `/var/log/jasmin/` and `sudo journalctl -u jasmind`
- **RabbitMQ**: `sudo journalctl -u rabbitmq-server`
- **Redis**: `sudo journalctl -u redis-server`

### Metrics
Jasmin exposes Prometheus metrics at `/metrics` endpoint for monitoring.

## 🚀 Production Deployment

### Resource Requirements
- **CPU**: 2 cores minimum
- **Memory**: 1GB minimum
- **Storage**: 10GB minimum
- **Network**: Stable internet connection

### Scaling
- **Horizontal**: Run multiple Jasmin instances
- **Vertical**: Increase resource limits
- **Load Balancing**: Use reverse proxy

### Backup
- **Configuration**: Backup `/etc/jasmin/`
- **Logs**: Backup `/var/log/jasmin/`
- **Database**: Backup Redis and RabbitMQ data

## 🔧 Troubleshooting

### Common Issues

#### Service Won't Start
```bash
# Check logs
sudo journalctl -u jasmind -n 50

# Check dependencies
make status

# Restart services
make restart
```

#### Can't Connect to CLI
```bash
# Check if port is open
telnet localhost 8990

# Check if service is running
sudo systemctl status jasmind
```

#### SMS Not Sending
```bash
# Check connector status
telnet localhost 8990
smppccm --list

# Check logs
sudo journalctl -u jasmind -f
```

#### Permission Issues
```bash
# Fix ownership
sudo chown -R jasmin:jasmin /etc/jasmin
sudo chown -R jasmin:jasmin /var/log/jasmin

# Fix permissions
sudo chmod -R 755 /etc/jasmin
sudo chmod -R 755 /var/log/jasmin
```

### Debug Mode
```bash
# Run in foreground
sudo systemctl stop jasmind
sudo -u jasmin jasmind

# Check specific service
sudo systemctl status jasmind
```

## 📚 API Reference

### HTTP API Endpoints

#### Send SMS
```
POST /send
Parameters:
- username: Authentication username
- password: Authentication password
- to: Destination number
- content: Message content
```

#### Health Check
```
GET /ping
Returns: PONG
```

#### Metrics
```
GET /metrics
Returns: Prometheus metrics
```

### SMPP Server
- **Port**: 2775
- **Protocol**: SMPP 3.4
- **Authentication**: Username/Password

## 🌍 Platform Support

### Supported Platforms
- ✅ **Ubuntu 20.04+** (Primary)
- ✅ **Ubuntu 18.04** (Limited)
- ✅ **Debian 10+** (Compatible)
- ✅ **Cloud VMs** (AWS, GCP, Azure, etc.)

## 📖 Documentation

### Official Documentation
- [Jasmin Documentation](https://docs.jasminsms.com/)
- [HTTP API Reference](https://docs.jasminsms.com/en/latest/apis/httpapi.html)
- [SMPP Server API](https://docs.jasminsms.com/en/latest/apis/smppserverapi.html)
- [Management CLI](https://docs.jasminsms.com/en/latest/apis/jcli.html)

### Community
- [GitHub Repository](https://github.com/jookies/jasmin)
- [Issues & Support](https://github.com/jookies/jasmin/issues)
- [Discussions](https://github.com/jookies/jasmin/discussions)

## 📚 **API Reference**

### **HTTP API Endpoints**

#### **Send SMS**
```
GET /send
Parameters:
- username: Authentication username (required)
- password: Authentication password (required)
- to: Destination phone number (required)
- content: Message content (required)

Example:
http://34.56.36.182:1401/send?username=admin&password=PASSWORD&to=+1234567890&content=Hello%20World
```

#### **Health Check**
```
GET /ping
Returns: pong

Example:
http://34.56.36.182:1401/ping
```

#### **Status Check**
```
GET /status
Returns: JSON status information

Example:
http://34.56.36.182:1401/status
```

### **Response Format**
```json
{
  "status": "success|error",
  "message_id": "unique-message-id",
  "to": "phone_number",
  "content": "message_content",
  "timestamp": "2025-09-04T10:29:10.991167"
}
```

### **Error Responses**
```json
{
  "status": "error",
  "message": "Error description"
}
```

## 🔒 **Security & Authentication**

### **⚠️ CRITICAL SECURITY NOTICE**
**NEVER commit real credentials to public repositories!** This repository uses placeholder credentials for documentation purposes only.

### **Proper Credential Management**

#### **For Production Use:**
1. **Use Environment Variables:**
   ```bash
   export SMS_GATEWAY_USERNAME="admin"
   export SMS_GATEWAY_PASSWORD="your_secure_password"
   ```

2. **Use Configuration Files (not in git):**
   ```bash
   # Create .env file (add to .gitignore)
   echo "SMS_GATEWAY_USERNAME=admin" > .env
   echo "SMS_GATEWAY_PASSWORD=your_secure_password" >> .env
   ```

3. **Use Secret Management:**
   - AWS Secrets Manager
   - Azure Key Vault
   - HashiCorp Vault
   - Kubernetes Secrets

### **Authentication Methods**
- **HTTP Basic Auth**: Username/password in URL parameters
- **Secure Passwords**: Randomly generated during installation
- **Environment Variables**: Credentials stored securely

### **Security Best Practices**
1. **Change default passwords** immediately after installation
2. **Use HTTPS** in production environments
3. **Implement rate limiting** for API calls
4. **Monitor logs** regularly for suspicious activity
5. **Keep system updated** with latest security patches
6. **Use firewall rules** to restrict access
7. **Regular security audits** of the system
8. **Never commit credentials** to version control
9. **Use strong, unique passwords**
10. **Rotate credentials regularly**

### **Access Control**
- **API Access**: Username/password authentication required
- **No anonymous access** to SMS sending
- **Logging** of all API calls and activities
- **Message tracking** with unique IDs

## 🛠️ **Troubleshooting**

### **Common Issues**

#### **Service Won't Start**
```bash
# Check service status
sudo systemctl status sms-gateway

# Check logs for errors
sudo journalctl -u sms-gateway -n 50

# Restart service
sudo systemctl restart sms-gateway
```

#### **Cannot Send SMS**
```bash
# Check if service is running
curl http://localhost:1401/ping

# Test authentication (replace with your credentials)
curl "http://localhost:1401/send?username=YOUR_USER&password=YOUR_PASSWORD&to=1234567890&content=test"

# Check logs
sudo tail -f /var/log/jasmin/sms-gateway.log
```

#### **Connection Refused**
```bash
# Check if port is open
sudo netstat -tlnp | grep :1401

# Check firewall
sudo ufw status

# Check service
sudo systemctl status sms-gateway
```

#### **Authentication Errors**
```bash
# Verify credentials
curl "http://localhost:1401/status"

# Check password encoding (replace with your password)
echo "YOUR_PASSWORD" | python3 -c "import urllib.parse; print(urllib.parse.quote(input().strip()))"
```

### **Debug Mode**
```bash
# Run service in foreground for debugging
sudo systemctl stop sms-gateway
sudo -u jasmin python3 /usr/local/bin/sms-gateway.py

# Check specific service logs
sudo journalctl -u sms-gateway --since "1 hour ago"
```

### **Dashboard Troubleshooting**

#### **Dashboard Won't Load**
```bash
# Check if proxy is running
lsof -i :8081

# Start the CORS proxy
python3 cors-proxy.py 8081

# Check for port conflicts
netstat -tlnp | grep :8081
```

#### **CORS Errors in Browser**
- Use the CORS proxy: `python3 cors-proxy.py 8081`
- Access dashboard at: `http://localhost:8081/dashboard.html`
- The proxy handles all cross-origin requests automatically

#### **Dashboard Shows "Failed to fetch"**
```bash
# Test SMS Gateway connectivity
curl http://localhost:1401/ping

# Test proxy connectivity
curl http://localhost:8081/proxy/ping

# Check proxy logs for errors
python3 cors-proxy.py 8081
```

#### **SMS Sending Fails**
```bash
# Test direct SMS sending (replace with your credentials)
curl "http://localhost:1401/send?username=YOUR_USER&password=YOUR_PASSWORD&to=test&content=test"

# Test through proxy
curl "http://localhost:8081/proxy/send?username=YOUR_USER&password=YOUR_PASSWORD&to=test&content=test"
```

## 📊 **Monitoring & Metrics**

### **Health Checks**
- **Gateway Status**: `http://localhost:1401/ping`
- **API Status**: `http://localhost:1401/status`
- **Service Status**: `sudo systemctl status sms-gateway`

### **Logs**
- **Service Logs**: `sudo journalctl -u sms-gateway -f`
- **Application Logs**: `sudo tail -f /var/log/jasmin/sms-gateway.log`
- **System Logs**: `/var/log/syslog`

### **Metrics**
- **Total API Calls**: Tracked in dashboard
- **Success Rate**: Monitored in real-time
- **Response Time**: Measured for each request
- **Uptime**: Tracked since service start

## 🚀 Deployment Guidelines

### Local Development
1. **Clone the repository**
2. **Run `make install`**
3. **Access the services** using the localhost URLs above
4. **Configure users and routes** via Management CLI

### Production Deployment
1. **Use a reverse proxy** (nginx/Apache) for HTTPS
2. **Set up monitoring** (Prometheus/Grafana)
3. **Configure backup** for data persistence
4. **Set up logging** aggregation
5. **Configure firewall** rules

### Cloud Deployment
1. **AWS/GCP/Azure**: Use Ubuntu VMs
2. **Load Balancing**: Use cloud load balancers
3. **Auto-scaling**: Configure based on CPU/memory usage
4. **Monitoring**: Use cloud monitoring services

### Security Checklist
- [ ] Change all default passwords immediately
- [ ] Secure the .env file (chmod 600)
- [ ] Enable HTTPS for production
- [ ] Configure firewall rules
- [ ] Set up monitoring alerts
- [ ] Regular security updates
- [ ] Backup configuration securely
- [ ] Enable fail2ban for intrusion prevention
- [ ] Regular security audits
- [ ] Never commit sensitive files to version control

## 📄 License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 🔧 **Installation Methods**

### **Method 1: Ubuntu/Debian Package (Recommended)**
```bash
# Add Jasmin repository
curl -s https://setup.jasminsms.com/deb | sudo bash

# Update package lists
sudo apt-get update

# Install Jasmin SMS Gateway
sudo apt-get install jasmin-sms-gateway

# Start services
sudo systemctl enable jasmind
sudo systemctl start jasmind
```

### **Method 2: Docker Installation (Production Ready)**
```bash
# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: "3.10"

services:
  redis:
    image: redis:alpine
    restart: unless-stopped
    healthcheck:
      test: redis-cli ping | grep PONG

  rabbit-mq:
    image: rabbitmq:3.10-management-alpine
    restart: unless-stopped
    healthcheck:
      test: rabbitmq-diagnostics -q ping

  jasmin:
    image: jookies/jasmin:latest
    restart: unless-stopped
    ports:
      - 2775:2775
      - 8990:8990
      - 1401:1401
    depends_on:
      redis:
        condition: service_healthy
      rabbit-mq:
        condition: service_healthy
    environment:
      REDIS_CLIENT_HOST: redis
      AMQP_BROKER_HOST: rabbit-mq
EOF

# Start services
docker-compose up -d
```

### **Method 3: Python PIP Installation**
```bash
# Create system user
sudo useradd jasmin

# Create required directories
sudo mkdir -p /etc/jasmin/resource
sudo mkdir -p /etc/jasmin/store
sudo mkdir -p /var/log/jasmin

# Set ownership
sudo chown -R jasmin:jasmin /etc/jasmin
sudo chown -R jasmin:jasmin /var/log/jasmin

# Install Jasmin
sudo pip install jasmin

# Download and install systemd service
# (Download from: https://github.com/jookies/jasmin/tree/master/misc/config/systemd)
sudo systemctl enable jasmind
sudo systemctl start jasmind
```

## 📚 **Official Jasmin Compliance**

This implementation follows the official Jasmin SMS Gateway guidelines:

### **✅ Installation Requirements Met**
- **Python 3**: Required and supported
- **Dependencies**: All required packages installed
- **System User**: `jasmin` user created with proper permissions
- **Directory Structure**: `/etc/jasmin/` and `/var/log/jasmin/` configured
- **Service Management**: Systemd service properly configured

### **✅ API Standards Compliance**
- **HTTP API**: RESTful API following Jasmin standards
- **Authentication**: Username/password authentication
- **Response Format**: JSON responses with proper status codes
- **Error Handling**: Comprehensive error responses
- **Message Tracking**: Unique message IDs for each SMS

### **✅ Security Standards**
- **Random Passwords**: Generated during installation
- **Environment Variables**: Secure credential storage
- **Firewall Configuration**: Proper port management
- **Logging**: Comprehensive activity logging
- **Access Control**: Authentication required for all operations

### **✅ Monitoring & Management**
- **Health Checks**: Ping and status endpoints
- **Service Management**: Systemd integration
- **Logging**: Structured logging with timestamps
- **Dashboard**: Real-time monitoring interface
- **Metrics**: API call tracking and statistics

### **✅ Production Ready Features**
- **Auto-restart**: Service recovery on failure
- **Resource Management**: Proper memory and CPU usage
- **Scalability**: Horizontal scaling support
- **Backup**: Configuration and log backup strategies
- **Documentation**: Comprehensive user and developer guides

## 📞 Support

- **Documentation**: [docs.jasminsms.com](https://docs.jasminsms.com/)
- **Issues**: [GitHub Issues](https://github.com/jookies/jasmin/issues)
- **Community**: [GitHub Discussions](https://github.com/jookies/jasmin/discussions)
- **Project Issues**: [This Repository Issues](https://github.com/Arnobrizwan/Jasmin-SMS-Gateway-setup/issues)

## 🎯 **What's Working**

✅ **SMS Gateway** running on Google Cloud VM  
✅ **HTTP API** for sending SMS messages  
✅ **Authentication** system working  
✅ **Message tracking** with unique IDs  
✅ **External access** from anywhere on the internet  
✅ **Logging** of all SMS messages  
✅ **Status monitoring** endpoints  
✅ **Service management** via systemd  
✅ **Firewall protection** configured  

## 🚀 **Next Steps**

1. **Integrate** with your applications
2. **Add more features** as needed
3. **Monitor** usage and performance
4. **Scale** by adding more instances
5. **Customize** for your specific needs

---

**🎉 Congratulations! Your SMS Gateway is fully operational and ready for production use! 🚀**

**Made with ❤️ by the Jasmin SMS Gateway community**