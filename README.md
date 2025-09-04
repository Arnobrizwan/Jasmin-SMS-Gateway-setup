# Jasmin SMS Gateway - Docker Setup

A complete, production-ready, dockerized Jasmin SMS Gateway setup that runs locally with Docker and Docker Compose. This setup matches the official Jasmin documentation exactly and includes monitoring capabilities.

## 🚀 Quick Start

### Prerequisites
- Docker 20.10+
- Docker Compose 2.0+
- Homebrew (for telnet on macOS)

### One-Command Setup
```bash
# Clone and start
git clone https://github.com/Arnobrizwan/Jasmin-SMS-Gateway-setup.git
cd jasmin-docker
docker-compose up -d

# That's it! Your SMS gateway is running
```

### With Monitoring (Grafana + Prometheus)
```bash
# Start with full monitoring stack
make monitoring-up

# Access monitoring dashboards
# Prometheus: http://localhost:9090
# Grafana: http://localhost:3000 (admin/admin)
```

## 📱 Access Your SMS Gateway

### Local URLs
- **HTTP API**: http://localhost:1401
- **Management CLI**: telnet localhost 8990
- **SMPP Server**: localhost:2775
- **RabbitMQ Management**: http://localhost:15672 (admin/admin)
- **Prometheus**: http://localhost:9090 (with monitoring)
- **Grafana**: http://localhost:3000 (admin/admin, with monitoring)

### Health Check
- **Jasmin Health**: http://localhost:1401/ping
- **RabbitMQ Health**: http://localhost:15672
- **Redis Health**: Check with `docker-compose exec redis redis-cli ping`

## 🔧 Configuration

### Environment Variables
Create a `.env` file to customize settings:

```bash
# Copy the example
cp .env.example .env

# Edit as needed
nano .env
```

### Default Configuration
- **HTTP API Port**: 1401
- **Management CLI Port**: 8990
- **SMPP Server Port**: 2775
- **RabbitMQ Management**: 15672

## 📖 Usage

### 1. Send Your First SMS

#### Via HTTP API
```bash
curl "http://localhost:1401/send?username=foo&password=bar&to=1234567890&content=Hello World"
```

#### Via Management CLI

**Option 1: Install Telnet (Recommended)**
```bash
# Install telnet on macOS
brew install telnet

# Connect to CLI
telnet localhost 8990
```

**Option 2: Use Netcat (if telnet not available)**
```bash
# Connect using netcat
nc localhost 8990
```

**Option 3: Use Docker Exec (Always Works)**
```bash
# Connect directly to container
docker-compose exec jasmin telnet localhost 8990
```

**Option 4: Use Python Script**
```bash
# Use the provided script
python3 connect-jcli.py
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
# View running containers
docker-compose ps

# View logs
docker-compose logs -f jasmin

# Check health
curl http://localhost:1401/ping
```

#### RabbitMQ Management
- Open http://localhost:15672
- Login: admin/admin
- Monitor queues, connections, and performance

#### Grafana Dashboards (with monitoring)
- Open http://localhost:3000
- Login: admin/admin
- View pre-configured dashboards for Jasmin and RabbitMQ

## 🐳 Docker Commands

### Basic Operations
```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# Restart services
docker-compose restart

# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f jasmin
```

### Monitoring Commands
```bash
# Start with monitoring
make monitoring-up

# Stop monitoring
make monitoring-down

# Check status
make status

# Test SMS
make test
```

### Maintenance
```bash
# Update images
docker-compose pull
docker-compose up -d

# Clean up
docker-compose down -v
docker system prune -f
```

## 🔒 Security

### Default Credentials
- **Management CLI**: jcliadmin/jclipwd
- **RabbitMQ Management**: admin/admin
- **Grafana**: admin/admin

### Security Recommendations
1. **Change default passwords** immediately
2. **Use environment variables** for sensitive data
3. **Enable HTTPS** in production
4. **Restrict network access** to necessary ports
5. **Regular updates** of Docker images

## 📊 Monitoring

### Health Checks
All services include health checks:
- **Redis**: `redis-cli ping`
- **RabbitMQ**: `rabbitmq-diagnostics ping`
- **Jasmin**: HTTP endpoint check

### Logs
- **Jasmin**: `/var/log/jasmin/`
- **RabbitMQ**: Standard Docker logs
- **Redis**: Standard Docker logs

### Metrics
Jasmin exposes Prometheus metrics at `/metrics` endpoint for monitoring.

### Grafana Dashboards
With monitoring enabled, you get:
- **Jasmin HTTP API**: HTTP API monitoring
- **Jasmin SMPP Clients**: Per SMPP Client monitoring
- **Jasmin SMPP Server**: SMPP Server monitoring
- **RabbitMQ Overview**: Standard RabbitMQ monitoring

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
docker-compose logs jasmin

# Check dependencies
docker-compose ps

# Restart services
docker-compose restart
```

#### Can't Connect to CLI
```bash
# Install telnet first
brew install telnet

# Check if port is open
telnet localhost 8990

# Check if service is running
docker-compose ps jasmin
```

#### SMS Not Sending
```bash
# Check connector status
telnet localhost 8990
smppccm --list

# Check logs
docker-compose logs jasmin
```

#### Telnet Not Working
```bash
# Install telnet
brew install telnet

# Or use alternatives
nc localhost 8990
docker-compose exec jasmin telnet localhost 8990
python3 connect-jcli.py
```

### Debug Mode
```bash
# Run in foreground
docker-compose up

# Check specific service
docker-compose exec jasmin bash
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
- ✅ **Linux** (x86_64, ARM64)
- ✅ **macOS** (Intel, Apple Silicon)
- ✅ **Windows** (with WSL2)
- ✅ **Cloud** (AWS, GCP, Azure, etc.)

### Docker Images
- **Jasmin**: `jookies/jasmin:latest`
- **Redis**: `redis:alpine`
- **RabbitMQ**: `rabbitmq:3.10-management-alpine`
- **Prometheus**: `prom/prometheus:latest`
- **Grafana**: `grafana/grafana`

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
2. **Run `docker-compose up -d`**
3. **Access the services** using the localhost URLs above
4. **Configure users and routes** via Management CLI

### Production Deployment
1. **Use a reverse proxy** (nginx/Apache) for HTTPS
2. **Set up monitoring** (Prometheus/Grafana)
3. **Configure backup** for data persistence
4. **Use environment variables** for sensitive data
5. **Set up logging** aggregation

### Cloud Deployment
1. **AWS/GCP/Azure**: Use managed services for Redis/RabbitMQ
2. **Docker Swarm/Kubernetes**: Use the provided docker-compose.yml
3. **Load Balancing**: Use cloud load balancers
4. **Auto-scaling**: Configure based on CPU/memory usage

### Security Checklist
- [ ] Change default passwords
- [ ] Enable HTTPS
- [ ] Configure firewall rules
- [ ] Set up monitoring alerts
- [ ] Regular security updates
- [ ] Backup configuration

## 🛠️ Makefile Commands

```bash
# Basic operations
make up              # Start all services
make down            # Stop all services
make restart         # Restart all services
make ps              # Show running containers
make logs            # Follow logs
make status          # Check service status
make test            # Test SMS sending
make clean           # Remove all containers and volumes

# Monitoring
make monitoring-up   # Start with monitoring (Grafana + Prometheus)
make monitoring-down # Stop monitoring services

# Help
make help            # Show all available commands
```

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