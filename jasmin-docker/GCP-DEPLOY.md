# ☁️ Google Cloud Platform Deployment

## 🚀 Quick GCP Deployment

Deploy Jasmin SMS Gateway on Google Cloud Platform in minutes!

## 📋 Prerequisites

- Google account
- Credit card (for verification, won't be charged for free tier)

## 🆓 Free Tier Resources

- **$300 credit** for 90 days
- **1 e2-micro VM** (1GB RAM) - Always free
- **30GB storage** - Always free
- **1GB network egress** - Always free

## 🚀 Step-by-Step Deployment

### **Step 1: Create Google Cloud Account**

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click "Get started for free"
3. Sign in with your Google account
4. Add payment method (required for verification)
5. Complete account setup

### **Step 2: Create VM Instance**

1. Go to "Compute Engine" → "VM instances"
2. Click "Create Instance"
3. Configure:
   - **Name**: `jasmin-sms-gateway`
   - **Region**: `us-central1` (Iowa)
   - **Machine type**: `e2-micro` (1 vCPU, 1GB RAM)
   - **Boot disk**: Ubuntu 22.04 LTS
   - **Firewall**: Allow HTTP traffic, Allow HTTPS traffic
4. Click "Create"

### **Step 3: Configure Firewall Rules**

1. Go to "VPC network" → "Firewall"
2. Click "Create Firewall Rule"
3. Configure:
   - **Name**: `jasmin-sms-gateway`
   - **Targets**: All instances in the network
   - **Source IP ranges**: `0.0.0.0/0`
   - **Protocols and ports**: TCP ports `22, 1401, 8990, 2775, 15672`
4. Click "Create"

### **Step 4: Connect to VM**

1. Click "SSH" button next to your VM instance
2. Or use gcloud command:
```bash
gcloud compute ssh jasmin-sms-gateway --zone=us-central1-a
```

### **Step 5: Deploy Jasmin SMS Gateway**

```bash
# One-command deployment
curl -s https://raw.githubusercontent.com/Arnobrizwan/Jasmin-SMS-Gateway-setup/main/jasmin-docker/deploy-gcp.sh | bash
```

## 🧪 Testing Your Deployment

### **Step 1: Check Services**
```bash
make status
```

### **Step 2: Get Credentials**
```bash
sudo cat /etc/jasmin/.env
```

### **Step 3: Test HTTP API**
```bash
curl http://localhost:1401/ping
```

### **Step 4: Connect to Management CLI**
```bash
make cli
# Login with credentials from .env file
```

### **Step 5: Create Test User**
```bash
# In CLI:
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

### **Step 6: Test SMS Sending**
```bash
curl "http://localhost:1401/send?username=testuser&password=testpass&to=1234567890&content=Test%20SMS"
```

## 📱 Access Your SMS Gateway

### **From VM:**
- **HTTP API**: `http://localhost:1401`
- **Management CLI**: `telnet localhost 8990`
- **SMPP Server**: `localhost:2775`
- **RabbitMQ Management**: `http://localhost:15672`

### **From Outside:**
- **HTTP API**: `http://YOUR_VM_EXTERNAL_IP:1401`
- **Management CLI**: `telnet YOUR_VM_EXTERNAL_IP 8990`
- **SMPP Server**: `YOUR_VM_EXTERNAL_IP:2775`
- **RabbitMQ Management**: `http://YOUR_VM_EXTERNAL_IP:15672`

## 🔧 Management Commands

```bash
# Service management
make start      # Start services
make stop       # Stop services
make restart    # Restart services
make status     # Check status
make logs       # View logs

# Testing
make test       # Test SMS sending
make cli        # Connect to Management CLI

# Cleanup
make clean      # Remove installation
```

## 💰 Cost Management

### **Free Tier Limits:**
- **e2-micro**: 1 vCPU, 1GB RAM (always free)
- **Storage**: 30GB (always free)
- **Network**: 1GB egress per month (always free)

### **Cost Optimization:**
- Use e2-micro instance (always free)
- Monitor usage in Cloud Console
- Set up billing alerts
- Stop instance when not in use

## 🔒 Security Features

- ✅ **Firewall rules** configured
- ✅ **Fail2ban** protection
- ✅ **Secure passwords** generated
- ✅ **UFW firewall** enabled
- ✅ **No hardcoded credentials**

## 🛠️ Troubleshooting

### **Can't Access from Outside:**
1. Check firewall rules in GCP Console
2. Verify VM is running
3. Check if ports are open

### **Services Won't Start:**
```bash
# Check logs
sudo journalctl -u jasmind -n 50
make restart
```

### **Permission Issues:**
```bash
# Fix ownership
sudo chown -R jasmin:jasmin /etc/jasmin
sudo chown -R jasmin:jasmin /var/log/jasmin
```

## 📚 Documentation

- **README.md** - Complete usage guide
- **SECURITY.md** - Security best practices
- **GCP-DEPLOY.md** - This deployment guide

---

**Ready to deploy on Google Cloud! ☁️🚀**
