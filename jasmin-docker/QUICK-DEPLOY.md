# 🚀 Quick Cloud Deployment

## ⚡ One-Command Deployment

Deploy Jasmin SMS Gateway on any Ubuntu cloud server in minutes!

### **Cloud Server Options:**

#### **AWS EC2 (Recommended)**
```bash
# 1. Launch Ubuntu 22.04 instance (t3.small)
# 2. Configure security group (ports 22, 1401, 8990, 2775, 15672)
# 3. SSH and run:
curl -s https://raw.githubusercontent.com/Arnobrizwan/Jasmin-SMS-Gateway-setup/main/jasmin-docker/deploy-cloud.sh | bash
```

#### **DigitalOcean (Simplest)**
```bash
# 1. Create Ubuntu 22.04 Droplet (1GB RAM)
# 2. Add SSH key
# 3. SSH and run:
curl -s https://raw.githubusercontent.com/Arnobrizwan/Jasmin-SMS-Gateway-setup/main/jasmin-docker/deploy-cloud.sh | bash
```

#### **Google Cloud Platform**
```bash
# 1. Create Ubuntu 22.04 VM (e2-small)
# 2. Enable firewall rules
# 3. SSH and run:
curl -s https://raw.githubusercontent.com/Arnobrizwan/Jasmin-SMS-Gateway-setup/main/jasmin-docker/deploy-cloud.sh | bash
```

## 📋 What Gets Installed

- ✅ **Jasmin SMS Gateway** (Official DEB package)
- ✅ **RabbitMQ Server** (Message broker)
- ✅ **Redis Server** (Database)
- ✅ **Python 3** + Dependencies
- ✅ **Systemd Services** (Auto-start)
- ✅ **Firewall** (UFW configured)
- ✅ **Fail2ban** (Security)
- ✅ **Secure Passwords** (Auto-generated)

## 🔧 After Deployment

### **Check Status:**
```bash
make status
```

### **Access Services:**
- **HTTP API**: `http://your-server-ip:1401`
- **Management CLI**: `telnet your-server-ip 8990`
- **SMPP Server**: `your-server-ip:2775`
- **RabbitMQ Management**: `http://your-server-ip:15672`

### **Get Credentials:**
```bash
sudo cat /etc/jasmin/.env
```

### **Test SMS:**
```bash
# Create test user first
make cli
# Login and create user, then:
make test
```

## 🛡️ Security Features

- ✅ **Random passwords** generated
- ✅ **Firewall** configured
- ✅ **Fail2ban** protection
- ✅ **Secure file permissions**
- ✅ **No hardcoded credentials**

## 📚 Full Documentation

- **README.md** - Complete usage guide
- **SECURITY.md** - Security best practices
- **CLOUD-DEPLOY.md** - Detailed cloud deployment
- **UBUNTU-SERVER-DEPLOY.md** - Server deployment guide

---

**Ready to deploy! 🚀**
