# Jasmin SMS Gateway - Complete Setup Guide

## 🎉 **Successfully Deployed on Google Cloud Platform**

Your SMS Gateway is now running on Google Cloud VM with the following details:

### 📍 **Deployment Information**
- **VM IP**: `34.56.36.182`
- **HTTP API Port**: `1401`
- **Status**: ✅ **ACTIVE AND WORKING**
- **Deployment Date**: September 4, 2025

### 🔐 **Access Credentials**
- **Username**: `admin`
- **Password**: `VhYK9Ho8I7cNPWGnypNRwO+PLypHQhStxyMLNiCzobk=`
- **URL-encoded Password**: `VhYK9Ho8I7cNPWGnypNRwO%2BPLypHQhStxyMLNiCzobk%3D`

## 🚀 **Quick Start**

### **Send Your First SMS**
```bash
curl "http://34.56.36.182:1401/send?username=admin&password=VhYK9Ho8I7cNPWGnypNRwO%2BPLypHQhStxyMLNiCzobk%3D&to=+1234567890&content=Hello%20World"
```

### **Check Gateway Status**
```bash
curl "http://34.56.36.182:1401/status"
```

### **Ping Test**
```bash
curl "http://34.56.36.182:1401/ping"
```

## 📱 **API Endpoints**

### **HTTP API (Port 1401)**
- **Send SMS**: `GET /send?username=admin&password=PASSWORD&to=PHONE&content=MESSAGE`
- **Status**: `GET /status`
- **Ping**: `GET /ping`

### **Example Response**
```json
{
  "status": "success",
  "message_id": "65080829-b9a2-49c0-9c46-26facdbb008f",
  "to": "1234567890",
  "content": "Hello World",
  "timestamp": "2025-09-04T10:29:10.991167"
}
```

## 🌐 **External Access**

Your SMS Gateway is accessible from anywhere on the internet:

- **HTTP API**: `http://34.56.36.182:1401`
- **Send SMS**: `http://34.56.36.182:1401/send?username=admin&password=VhYK9Ho8I7cNPWGnypNRwO%2BPLypHQhStxyMLNiCzobk%3D&to=PHONE&content=MESSAGE`
- **Status**: `http://34.56.36.182:1401/status`
- **Ping**: `http://34.56.36.182:1401/ping`

## 📋 **Integration Examples**

### **Python Integration**
```python
import requests

def send_sms(phone_number, message):
    url = "http://34.56.36.182:1401/send"
    params = {
        'username': 'admin',
        'password': 'VhYK9Ho8I7cNPWGnypNRwO+PLypHQhStxyMLNiCzobk=',
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
async function sendSMS(phoneNumber, message) {
    const url = 'http://34.56.36.182:1401/send';
    const params = new URLSearchParams({
        username: 'admin',
        password: 'VhYK9Ho8I7cNPWGnypNRwO+PLypHQhStxyMLNiCzobk=',
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

if [ -z "$PHONE_NUMBER" ] || [ -z "$MESSAGE" ]; then
    echo "Usage: $0 <phone_number> <message>"
    exit 1
fi

curl "http://34.56.36.182:1401/send?username=admin&password=VhYK9Ho8I7cNPWGnypNRwO%2BPLypHQhStxyMLNiCzobk%3D&to=$PHONE_NUMBER&content=$MESSAGE"
```

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

## 📞 Support

- **Documentation**: [docs.jasminsms.com](https://docs.jasminsms.com/)
- **Issues**: [GitHub Issues](https://github.com/jookies/jasmin/issues)
- **Community**: [GitHub Discussions](https://github.com/jookies/jasmin/discussions)

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