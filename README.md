# Jasmin SMS Gateway - Ubuntu Installation

A complete, production-ready Jasmin SMS Gateway setup for Ubuntu following the official documentation.

## 🚀 Quick Start

### Prerequisites
- Ubuntu 20.04 or newer
- sudo privileges
- Internet connection

### One-Command Installation
```bash
# Clone and install
git clone https://github.com/Arnobrizwan/Jasmin-SMS-Gateway-setup.git
cd jasmin-docker
make install

# That's it! Your SMS gateway is running
```

## 📱 Access Your SMS Gateway

### Local URLs
- **HTTP API**: http://localhost:1401
- **Management CLI**: telnet localhost 8990
- **SMPP Server**: localhost:2775
- **RabbitMQ Management**: http://localhost:15672 (admin/admin)

### Health Check
- **Jasmin Health**: http://localhost:1401/ping
- **RabbitMQ Health**: http://localhost:15672
- **Redis Health**: Check with `redis-cli ping`

## 🔧 Configuration

### Default Configuration
- **HTTP API Port**: 1401
- **Management CLI Port**: 8990
- **SMPP Server Port**: 2775
- **RabbitMQ Management**: 15672

### Configuration Files
- **Main Config**: `/etc/jasmin/jasmin.cfg`
- **Logs**: `/var/log/jasmin/`
- **Store**: `/etc/jasmin/store/`

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
- **Management CLI**: jcliadmin/jclipwd
- **RabbitMQ Management**: admin/admin

### Security Recommendations
1. **Change default passwords** immediately
2. **Configure firewall** rules
3. **Use HTTPS** in production
4. **Regular updates** of system packages
5. **Monitor logs** regularly

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
- [ ] Change default passwords
- [ ] Enable HTTPS
- [ ] Configure firewall rules
- [ ] Set up monitoring alerts
- [ ] Regular security updates
- [ ] Backup configuration

## 📄 License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

- **Documentation**: [docs.jasminsms.com](https://docs.jasminsms.com/)
- **Issues**: [GitHub Issues](https://github.com/jookies/jasmin/issues)
- **Community**: [GitHub Discussions](https://github.com/jookies/jasmin/discussions)

---

**Made with ❤️ by the Jasmin SMS Gateway community**