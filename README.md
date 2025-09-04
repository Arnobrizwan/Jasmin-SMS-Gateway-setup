# Jasmin SMS Gateway - Docker Setup

A complete, production-ready, dockerized Jasmin SMS Gateway setup that can run anywhere with Docker and Docker Compose.

## 🚀 Quick Start

### Prerequisites
- Docker 20.10+
- Docker Compose 2.0+

### One-Command Setup
```bash
# Clone and start
git clone <repository-url>
cd jasmin-docker
docker-compose up -d

# That's it! Your SMS gateway is running
```

### Deploy to Cloud (Free)
```bash
# Deploy to Render.com (free hosting)
make deploy-render

# Or use the web interface
# Visit: https://render.com
```

### Access Points
- **HTTP API**: http://localhost:1401
- **Management CLI**: telnet localhost 8990
- **SMPP Server**: localhost:2775
- **RabbitMQ Management**: http://localhost:15672 (admin/admin)

## 📋 What You Get

### Core Services
- **Jasmin SMS Gateway** - The main SMS gateway service
- **Redis** - For message ID mapping and delivery receipts
- **RabbitMQ** - AMQP message broker for core functionality

### Features
- ✅ **HTTP API** for sending SMS
- ✅ **SMPP Server** for receiving SMS
- ✅ **Management CLI** for configuration
- ✅ **Health checks** and auto-restart
- ✅ **Resource limits** for production use
- ✅ **Security optimizations**

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
```bash
# Connect to CLI
telnet localhost 8990

# Login (default: jcliadmin/jclipwd)
Username: jcliadmin
Password: jclipwd

# Create a user
user -a
> username foo
> password bar
> gid default
> uid foo
> ok

# Create a group
group -a
> gid default
> ok

# Create a route
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
docker-compose exec jasmin curl http://localhost:1401/ping
```

#### RabbitMQ Management
- Open http://localhost:15672
- Login: admin/admin
- Monitor queues, connections, and performance

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