# Ubuntu Server Deployment Guide

## 🐧 Deploy Jasmin SMS Gateway on Real Ubuntu Server

This guide helps you deploy the Jasmin SMS Gateway on a real Ubuntu server (not Docker).

## 📋 Server Requirements

### **Minimum Requirements:**
- **Ubuntu 20.04+** (LTS recommended)
- **2GB RAM** minimum (4GB recommended)
- **10GB disk space** minimum
- **Root/sudo access**
- **Internet connection**

### **Network Requirements:**
- **Port 22** (SSH) - for server access
- **Port 1401** (HTTP API) - for SMS sending
- **Port 8990** (Management CLI) - for configuration
- **Port 2775** (SMPP Server) - for SMPP connections
- **Port 15672** (RabbitMQ Management) - for monitoring

## 🚀 Quick Deployment

### **Option 1: Cloud Server (Recommended)**

#### **AWS EC2:**
```bash
# 1. Launch Ubuntu 22.04 LTS instance
#    - Instance type: t3.small or larger
#    - Security group: Allow ports 22, 1401, 8990, 2775, 15672
#    - Storage: 20GB minimum

# 2. SSH into your instance
ssh -i your-key.pem ubuntu@your-server-ip

# 3. Clone and deploy
git clone https://github.com/Arnobrizwan/Jasmin-SMS-Gateway-setup.git
cd jasmin-docker
chmod +x test-real-ubuntu.sh
./test-real-ubuntu.sh
chmod +x install-ubuntu.sh
./install-ubuntu.sh
```

#### **Google Cloud Platform:**
```bash
# 1. Create Ubuntu 22.04 VM
#    - Machine type: e2-small or larger
#    - Firewall: Allow ports 22, 1401, 8990, 2775, 15672

# 2. SSH into your instance
gcloud compute ssh your-instance-name --zone=your-zone

# 3. Clone and deploy
git clone https://github.com/Arnobrizwan/Jasmin-SMS-Gateway-setup.git
cd jasmin-docker
chmod +x test-real-ubuntu.sh
./test-real-ubuntu.sh
chmod +x install-ubuntu.sh
./install-ubuntu.sh
```

#### **DigitalOcean:**
```bash
# 1. Create Ubuntu 22.04 Droplet
#    - Size: 1GB or larger
#    - Firewall: Allow ports 22, 1401, 8990, 2775, 15672

# 2. SSH into your droplet
ssh root@your-droplet-ip

# 3. Clone and deploy
git clone https://github.com/Arnobrizwan/Jasmin-SMS-Gateway-setup.git
cd jasmin-docker
chmod +x test-real-ubuntu.sh
./test-real-ubuntu.sh
chmod +x install-ubuntu.sh
./install-ubuntu.sh
```

### **Option 2: Local Ubuntu VM**

#### **VirtualBox:**
```bash
# 1. Download Ubuntu 22.04 LTS ISO
# 2. Create new VM with 2GB RAM, 20GB disk
# 3. Install Ubuntu 22.04
# 4. Enable SSH: sudo apt install openssh-server
# 5. Follow deployment steps above
```

#### **VMware:**
```bash
# 1. Download Ubuntu 22.04 LTS ISO
# 2. Create new VM with 2GB RAM, 20GB disk
# 3. Install Ubuntu 22.04
# 4. Enable SSH: sudo apt install openssh-server
# 5. Follow deployment steps above
```

### **Option 3: WSL2 (Windows)**
```bash
# 1. Install WSL2 with Ubuntu
wsl --install -d Ubuntu-22.04

# 2. Update WSL2
wsl --update

# 3. Launch Ubuntu
wsl -d Ubuntu-22.04

# 4. Follow deployment steps above
```

## 🔧 Step-by-Step Deployment

### **Step 1: Pre-Installation Test**
```bash
# Run the test script
chmod +x test-real-ubuntu.sh
./test-real-ubuntu.sh
```

**Expected Output:**
```
🐧 Real Ubuntu Server Test for Jasmin SMS Gateway
=================================================
📋 Testing on Ubuntu 22.04
✅ Ubuntu version is supported
✅ Found installation script
✅ Script syntax is valid
✅ apt-get available
✅ systemctl available
✅ All required packages can be installed
✅ Password generation works
✅ install-ubuntu.sh is executable
✅ ubuntu-commands.sh is executable
✅ jasmin.cfg exists
✅ Environment variable substitution configured
✅ jasmind.service exists
✅ Service configured to run as jasmin user
✅ Makefile exists
✅ Makefile targets work
✅ README.md exists
✅ README contains Ubuntu installation info
✅ SECURITY.md exists
✅ ubuntu-commands.sh exists
✅ ubuntu-commands.sh help works
✅ RabbitMQ installation included
✅ Redis installation included
✅ Jasmin package installation included
✅ Secure password generation included
✅ No hardcoded passwords in templates

🎉 All tests passed!
```

### **Step 2: Installation**
```bash
# Run the installation
chmod +x install-ubuntu.sh
./install-ubuntu.sh
```

**Expected Output:**
```
🚀 Jasmin SMS Gateway - Ubuntu Installation
=============================================
📋 Detected Ubuntu version: 22.04
✅ Ubuntu version is supported
🔄 Updating system packages...
📦 Installing dependencies...
🐰 Configuring RabbitMQ...
🔐 Generated RabbitMQ password: [RANDOM_PASSWORD]
🔐 Generated Jasmin HTTP password: [RANDOM_PASSWORD]
🔐 Generated Jasmin CLI password: [RANDOM_PASSWORD]
📱 Installing Jasmin SMS Gateway...
👤 Setting up system user and directories...
🔐 Creating environment configuration...
🚀 Starting Jasmin service...
⏳ Waiting for services to be ready...
🔍 Checking service status...
Redis status: active
RabbitMQ status: active
Jasmin status: active
🧪 Testing connections...
PONG
✅ RabbitMQ connection successful
✅ Jasmin HTTP API responding

🎉 Installation complete!

📱 Access your SMS gateway:
  HTTP API: http://localhost:1401
  Management CLI: telnet localhost 8990
  SMPP Server: localhost:2775
  RabbitMQ Management: http://localhost:15672

🔐 IMPORTANT - Save these credentials:
  Jasmin HTTP API: jcliadmin / [GENERATED_PASSWORD]
  Jasmin Management CLI: jcliadmin / [GENERATED_PASSWORD]
  RabbitMQ Management: admin / [GENERATED_PASSWORD]

⚠️  SECURITY WARNING:
  - Change all default passwords immediately
  - Credentials are saved in /etc/jasmin/.env
  - Keep this file secure and never commit it to version control
```

### **Step 3: Verification**
```bash
# Check service status
make status

# Test HTTP API
curl http://localhost:1401/ping

# Test Management CLI
make cli
```

## 🧪 Testing SMS Functionality

### **Step 1: Connect to Management CLI**
```bash
# Connect to CLI
make cli

# Login with generated credentials
Username: jcliadmin
Password: [GENERATED_PASSWORD]
```

### **Step 2: Create Test User**
```bash
# Create group
group -a
> gid testgroup
> ok

# Create user
user -a
> username testuser
> password testpass
> gid testgroup
> uid testuser
> ok

# Exit CLI
quit
```

### **Step 3: Test SMS Sending**
```bash
# Test SMS via HTTP API
curl "http://localhost:1401/send?username=testuser&password=testpass&to=1234567890&content=Test%20SMS"

# Expected response:
# Success "message-id-here"
```

## 🔍 Troubleshooting

### **Common Issues:**

#### **Services Won't Start**
```bash
# Check logs
sudo journalctl -u jasmind -n 50
sudo journalctl -u rabbitmq-server -n 50
sudo journalctl -u redis-server -n 50

# Check status
sudo systemctl status jasmind
sudo systemctl status rabbitmq-server
sudo systemctl status redis-server
```

#### **Permission Issues**
```bash
# Fix ownership
sudo chown -R jasmin:jasmin /etc/jasmin
sudo chown -R jasmin:jasmin /var/log/jasmin

# Fix permissions
sudo chmod -R 755 /etc/jasmin
sudo chmod -R 755 /var/log/jasmin
```

#### **Port Conflicts**
```bash
# Check what's using ports
sudo netstat -tlnp | grep :1401
sudo netstat -tlnp | grep :8990
sudo netstat -tlnp | grep :2775
sudo netstat -tlnp | grep :15672
```

#### **Firewall Issues**
```bash
# Check firewall status
sudo ufw status

# Allow required ports
sudo ufw allow 1401/tcp
sudo ufw allow 8990/tcp
sudo ufw allow 2775/tcp
sudo ufw allow 15672/tcp
```

## 📊 Performance Testing

### **Load Testing**
```bash
# Install Apache Bench
sudo apt install apache2-utils

# Test HTTP API performance
ab -n 100 -c 10 "http://localhost:1401/send?username=testuser&password=testpass&to=1234567890&content=Test%20SMS"
```

### **Monitoring**
```bash
# Monitor system resources
htop

# Monitor Jasmin logs
sudo tail -f /var/log/jasmin/jasmin.log

# Monitor RabbitMQ
sudo rabbitmq-diagnostics status
```

## 🔒 Security Hardening

### **Firewall Configuration**
```bash
# Install and configure UFW
sudo apt install ufw
sudo ufw allow 22/tcp
sudo ufw allow 1401/tcp
sudo ufw allow 8990/tcp
sudo ufw allow 2775/tcp
sudo ufw allow 15672/tcp
sudo ufw enable
```

### **SSL/TLS Setup**
```bash
# Install nginx for HTTPS
sudo apt install nginx certbot python3-certbot-nginx

# Create SSL certificate
sudo certbot --nginx -d your-domain.com

# Configure nginx reverse proxy
sudo nano /etc/nginx/sites-available/jasmin
```

## 📈 Production Readiness

### **Checklist:**
- [ ] All services running
- [ ] Passwords changed from defaults
- [ ] Firewall configured
- [ ] SSL/TLS enabled (if needed)
- [ ] Monitoring configured
- [ ] Backup strategy in place
- [ ] Log rotation configured
- [ ] Security updates applied

### **Performance Optimization:**
```bash
# Increase file limits
echo "* soft nofile 65536" | sudo tee -a /etc/security/limits.conf
echo "* hard nofile 65536" | sudo tee -a /etc/security/limits.conf

# Optimize Redis
sudo nano /etc/redis/redis.conf
# Set: maxmemory 256mb
# Set: maxmemory-policy allkeys-lru

# Optimize RabbitMQ
sudo nano /etc/rabbitmq/rabbitmq.conf
# Set: vm_memory_high_watermark.relative = 0.6
```

## 📞 Support

If you encounter issues during deployment:

1. **Check logs** first: `sudo journalctl -u jasmind -f`
2. **Verify services**: `make status`
3. **Test connectivity**: `curl http://localhost:1401/ping`
4. **Check documentation**: `README.md` and `SECURITY.md`
5. **Create GitHub issue** with detailed error information

---

**Ready to deploy on real Ubuntu server! 🚀**
