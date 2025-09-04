# ☁️ Cloud Server Deployment Guide

## 🚀 Quick Cloud Deployment

Deploy Jasmin SMS Gateway on cloud servers in minutes!

## 📋 Cloud Provider Options

### **1. AWS EC2 (Recommended)**

#### **Step 1: Launch Instance**
```bash
# 1. Go to AWS EC2 Console
# 2. Click "Launch Instance"
# 3. Choose "Ubuntu Server 22.04 LTS"
# 4. Select instance type: t3.small (2 vCPU, 2GB RAM)
# 5. Configure security group:
#    - SSH (22) - Your IP
#    - HTTP (80) - 0.0.0.0/0
#    - Custom (1401) - 0.0.0.0/0
#    - Custom (8990) - Your IP
#    - Custom (2775) - 0.0.0.0/0
#    - Custom (15672) - Your IP
# 6. Launch instance
```

#### **Step 2: Connect and Deploy**
```bash
# Connect to your instance
ssh -i your-key.pem ubuntu@your-ec2-ip

# One-command deployment
curl -s https://raw.githubusercontent.com/Arnobrizwan/Jasmin-SMS-Gateway-setup/main/jasmin-docker/deploy-cloud.sh | bash
```

### **2. Google Cloud Platform**

#### **Step 1: Create VM**
```bash
# 1. Go to GCP Console > Compute Engine
# 2. Click "Create Instance"
# 3. Choose "Ubuntu 22.04 LTS"
# 4. Machine type: e2-small (2 vCPU, 2GB RAM)
# 5. Firewall: Allow HTTP traffic, Allow HTTPS traffic
# 6. Create instance
```

#### **Step 2: Connect and Deploy**
```bash
# Connect to your instance
gcloud compute ssh your-instance-name --zone=your-zone

# One-command deployment
curl -s https://raw.githubusercontent.com/Arnobrizwan/Jasmin-SMS-Gateway-setup/main/jasmin-docker/deploy-cloud.sh | bash
```

### **3. DigitalOcean**

#### **Step 1: Create Droplet**
```bash
# 1. Go to DigitalOcean Console
# 2. Click "Create Droplet"
# 3. Choose "Ubuntu 22.04 LTS"
# 4. Size: 1GB RAM (Basic plan)
# 5. Add SSH key
# 6. Create droplet
```

#### **Step 2: Connect and Deploy**
```bash
# Connect to your droplet
ssh root@your-droplet-ip

# One-command deployment
curl -s https://raw.githubusercontent.com/Arnobrizwan/Jasmin-SMS-Gateway-setup/main/jasmin-docker/deploy-cloud.sh | bash
```

### **4. Linode**

#### **Step 1: Create Instance**
```bash
# 1. Go to Linode Console
# 2. Click "Create Instance"
# 3. Choose "Ubuntu 22.04 LTS"
# 4. Plan: 1GB RAM
# 5. Add SSH key
# 6. Create instance
```

#### **Step 2: Connect and Deploy**
```bash
# Connect to your instance
ssh root@your-linode-ip

# One-command deployment
curl -s https://raw.githubusercontent.com/Arnobrizwan/Jasmin-SMS-Gateway-setup/main/jasmin-docker/deploy-cloud.sh | bash
```

## 🔧 Manual Deployment

If you prefer manual deployment:

```bash
# 1. Connect to your cloud server
ssh user@your-server-ip

# 2. Clone repository
git clone https://github.com/Arnobrizwan/Jasmin-SMS-Gateway-setup.git
cd jasmin-docker

# 3. Run pre-installation test
chmod +x test-real-ubuntu.sh
./test-real-ubuntu.sh

# 4. Install Jasmin
chmod +x install-ubuntu.sh
./install-ubuntu.sh

# 5. Configure firewall
sudo ufw allow 1401/tcp
sudo ufw allow 8990/tcp
sudo ufw allow 2775/tcp
sudo ufw allow 15672/tcp
sudo ufw enable
```

## 🧪 Testing Your Deployment

### **Step 1: Check Services**
```bash
# Check service status
make status

# Expected output:
# Redis: active
# RabbitMQ: active
# Jasmin: active
```

### **Step 2: Test HTTP API**
```bash
# Test health endpoint
curl http://your-server-ip:1401/ping

# Expected output: PONG
```

### **Step 3: Connect to Management CLI**
```bash
# Connect to CLI
make cli

# Login with generated credentials
# Username: jcliadmin
# Password: [check /etc/jasmin/.env]
```

### **Step 4: Create Test User**
```bash
# In the CLI, create a test user
group -a
> gid testgroup
> ok

user -a
> username testuser
> password testpass
> gid testgroup
> uid testuser
> ok

quit
```

### **Step 5: Test SMS Sending**
```bash
# Test SMS via HTTP API
curl "http://your-server-ip:1401/send?username=testuser&password=testpass&to=1234567890&content=Test%20SMS"

# Expected output: Success "message-id-here"
```

## 🔒 Security Configuration

### **Firewall Rules**
```bash
# Check firewall status
sudo ufw status

# Allow only necessary ports
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 1401/tcp  # HTTP API
sudo ufw allow 8990/tcp  # Management CLI (restrict to your IP)
sudo ufw allow 2775/tcp  # SMPP Server
sudo ufw allow 15672/tcp # RabbitMQ Management (restrict to your IP)
```

### **Fail2ban Protection**
```bash
# Check fail2ban status
sudo systemctl status fail2ban

# View banned IPs
sudo fail2ban-client status jasmin-http
sudo fail2ban-client status jasmin-cli
```

### **SSL/TLS Setup (Optional)**
```bash
# Install nginx for HTTPS
sudo apt install nginx certbot python3-certbot-nginx

# Create SSL certificate
sudo certbot --nginx -d your-domain.com

# Configure nginx reverse proxy
sudo nano /etc/nginx/sites-available/jasmin
```

## 📊 Monitoring

### **System Monitoring**
```bash
# Monitor system resources
htop

# Monitor disk usage
df -h

# Monitor memory usage
free -h
```

### **Jasmin Monitoring**
```bash
# Monitor Jasmin logs
sudo tail -f /var/log/jasmin/jasmin.log

# Monitor RabbitMQ
sudo rabbitmq-diagnostics status

# Check service status
make status
```

## 🔧 Troubleshooting

### **Common Issues**

#### **Services Won't Start**
```bash
# Check logs
sudo journalctl -u jasmind -n 50
sudo journalctl -u rabbitmq-server -n 50
sudo journalctl -u redis-server -n 50

# Restart services
make restart
```

#### **Can't Access from Outside**
```bash
# Check firewall
sudo ufw status

# Check if ports are listening
sudo netstat -tlnp | grep -E ":(1401|8990|2775|15672)"

# Check security group (AWS) or firewall rules (other providers)
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

## 💰 Cost Optimization

### **AWS EC2**
- **t3.small**: ~$15/month
- **t3.micro**: ~$8/month (1 vCPU, 1GB RAM)
- **Spot instances**: Up to 90% savings

### **Google Cloud**
- **e2-small**: ~$12/month
- **e2-micro**: ~$6/month (1 vCPU, 1GB RAM)
- **Preemptible instances**: Up to 80% savings

### **DigitalOcean**
- **1GB Droplet**: ~$6/month
- **512MB Droplet**: ~$4/month

### **Linode**
- **1GB Instance**: ~$5/month
- **512MB Instance**: ~$3/month

## 📞 Support

If you encounter issues:

1. **Check logs**: `sudo journalctl -u jasmind -f`
2. **Verify services**: `make status`
3. **Test connectivity**: `curl http://localhost:1401/ping`
4. **Check documentation**: `README.md` and `SECURITY.md`
5. **Create GitHub issue** with detailed error information

---

**Ready to deploy on cloud! ☁️🚀**
