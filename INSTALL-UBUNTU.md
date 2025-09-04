# Ubuntu Installation Guide

## 🚀 Quick Installation

### Prerequisites
- Ubuntu 20.04 or newer
- sudo privileges
- Internet connection

### One-Command Installation
```bash
# Clone the repository
git clone https://github.com/Arnobrizwan/Jasmin-SMS-Gateway-setup.git
cd jasmin-docker

# Install everything
make install
```

## 📋 What Gets Installed

### System Packages
- **RabbitMQ Server** - Message broker
- **Redis Server** - In-memory database
- **Python 3** - Runtime environment
- **Dependencies** - All required libraries

### Jasmin SMS Gateway
- **Main Package** - jasmin-sms-gateway
- **System Service** - jasmind.service
- **Configuration** - /etc/jasmin/jasmin.cfg
- **Logs** - /var/log/jasmin/
- **Store** - /etc/jasmin/store/

### Services Created
- **jasmind** - Main Jasmin service
- **rabbitmq-server** - Message broker
- **redis-server** - Database

## 🔧 Post-Installation

### 1. Verify Installation
```bash
# Check service status
make status

# Test HTTP API
curl http://localhost:1401/ping

# Test Management CLI
telnet localhost 8990
```

### 2. Configure Users and Routes
```bash
# Connect to Management CLI
make cli

# Login with: jcliadmin/jclipwd
# Create users and routes as needed
```

### 3. Test SMS Sending
```bash
# Test SMS (will fail until user is created)
make test
```

## 🛠️ Management Commands

### Service Management
```bash
make start      # Start all services
make stop       # Stop all services
make restart    # Restart all services
make status     # Check status
make logs       # View logs
```

### Testing
```bash
make test       # Test SMS sending
make cli        # Connect to Management CLI
```

### Maintenance
```bash
make clean      # Remove installation
```

## 🔒 Security Configuration

### Change Default Passwords
1. **RabbitMQ Management**:
   ```bash
   sudo rabbitmqctl change_password admin newpassword
   ```

2. **Jasmin Management CLI**:
   - Connect via `make cli`
   - Use `user -u jcliadmin` to update password

### Firewall Configuration
```bash
# Allow required ports
sudo ufw allow 1401/tcp  # HTTP API
sudo ufw allow 8990/tcp  # Management CLI
sudo ufw allow 2775/tcp  # SMPP Server
sudo ufw allow 15672/tcp # RabbitMQ Management
```

## 📊 Monitoring Setup

### Enable Prometheus Metrics
Jasmin automatically exposes metrics at `/metrics` endpoint.

### Log Monitoring
```bash
# Follow all logs
sudo journalctl -u jasmind -f

# Follow specific logs
tail -f /var/log/jasmin/messages.log
```

## 🚨 Troubleshooting

### Common Issues

#### Services Won't Start
```bash
# Check logs
sudo journalctl -u jasmind -n 50

# Check dependencies
sudo systemctl status rabbitmq-server
sudo systemctl status redis-server
```

#### Permission Issues
```bash
# Fix ownership
sudo chown -R jasmin:jasmin /etc/jasmin
sudo chown -R jasmin:jasmin /var/log/jasmin
```

#### Port Conflicts
```bash
# Check what's using ports
sudo netstat -tlnp | grep :1401
sudo netstat -tlnp | grep :8990
sudo netstat -tlnp | grep :2775
```

## 📚 Next Steps

1. **Read the main README.md** for detailed usage instructions
2. **Configure SMPP connections** for your SMS provider
3. **Set up monitoring** with Prometheus and Grafana
4. **Configure backup** for production use
5. **Set up HTTPS** for secure access

## 🆘 Support

- **Documentation**: [docs.jasminsms.com](https://docs.jasminsms.com/)
- **Issues**: [GitHub Issues](https://github.com/jookies/jasmin/issues)
- **Community**: [GitHub Discussions](https://github.com/jookies/jasmin/discussions)
