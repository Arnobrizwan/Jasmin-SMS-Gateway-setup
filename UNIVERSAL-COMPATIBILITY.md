# Universal Compatibility Guide

This Jasmin SMS Gateway setup is designed to run **anywhere** with automatic platform detection and compatibility handling.

## 🌍 Supported Platforms

### Operating Systems
- ✅ **Linux** (x86_64, ARM64, ARMv7)
- ✅ **macOS** (Intel, Apple Silicon)
- ✅ **Windows** (with WSL2 or Docker Desktop)
- ✅ **FreeBSD** (with Docker support)
- ✅ **OpenBSD** (with Docker support)

### Architectures
- ✅ **x86_64/AMD64** - Optimal performance
- ✅ **ARM64/AArch64** - Native ARM support
- ✅ **ARMv7** - Raspberry Pi and embedded devices
- ✅ **i386** - Legacy 32-bit systems

### Cloud Platforms
- ✅ **AWS** (EC2, ECS, EKS)
- ✅ **Google Cloud** (Compute Engine, GKE)
- ✅ **Azure** (Virtual Machines, AKS)
- ✅ **DigitalOcean** (Droplets, App Platform)
- ✅ **Linode** (Nanode, Dedicated CPU)
- ✅ **Vultr** (Cloud Compute)
- ✅ **Hetzner** (Cloud, Dedicated)

### Container Platforms
- ✅ **Docker** (any version 20.10+)
- ✅ **Docker Compose** (1.29+ or 2.0+)
- ✅ **Podman** (with Docker Compose compatibility)
- ✅ **Kubernetes** (with Docker Compose conversion)

## 🚀 Quick Start (Any Platform)

```bash
# 1. Clone the repository
git clone <repository-url>
cd jasmin-docker

# 2. Run universal setup (detects platform automatically)
make setup

# 3. Start the services
make up

# 4. Bootstrap Jasmin
make bootstrap

# 5. Test SMS sending
make test

# 6. Add monitoring (optional)
make monitoring-up
```

## 🔍 Platform Detection

The setup automatically detects and optimizes for your platform:

```bash
# Check your platform
make platform

# Run universal setup
make setup
```

### What Platform Detection Does

1. **Detects OS and Architecture**
   - Identifies Linux, macOS, Windows, etc.
   - Determines x86_64, ARM64, ARMv7, etc.

2. **Checks Available Tools**
   - Tests for curl, wget, nc, telnet
   - Verifies Docker and Docker Compose
   - Checks for required utilities

3. **Applies Platform Optimizations**
   - Apple Silicon: Uses linux/amd64 for Jasmin compatibility
   - ARM64 Linux: Uses native ARM64 for better performance
   - x86_64 Linux: Uses optimal native platform

4. **Creates Platform-Specific Configurations**
   - Generates docker-compose.override.yml for Apple Silicon
   - Sets appropriate resource limits
   - Configures network settings

## 🛠️ Platform-Specific Features

### Apple Silicon (M1/M2/M3 Macs)
- **Automatic Platform Override**: Uses linux/amd64 for Jasmin compatibility
- **Native ARM64 Support**: Redis, RabbitMQ, Prometheus, Grafana run natively
- **Performance Optimization**: Balanced approach for best compatibility

### ARM64 Linux (Raspberry Pi, ARM Servers)
- **Native ARM64**: All services run on native ARM64 platform
- **Resource Optimization**: Lower resource requirements
- **Raspberry Pi Ready**: Tested on Pi 4 and Pi 5

### x86_64 Linux (Standard Servers)
- **Optimal Performance**: All services run natively
- **No Platform Warnings**: Clean execution
- **Production Ready**: Ideal for production deployments

### Windows (WSL2/Docker Desktop)
- **WSL2 Support**: Full compatibility with Windows Subsystem for Linux
- **Docker Desktop**: Works with both Linux and Windows containers
- **Cross-Platform**: Seamless development experience

## 🔧 Universal Scripts

All scripts are designed to work on any platform:

### `scripts/detect-platform.sh`
- Detects OS, architecture, and available tools
- Provides platform-specific recommendations
- Exports environment variables for other scripts

### `scripts/setup-universal.sh`
- Runs comprehensive platform detection
- Checks Docker and Docker Compose availability
- Creates platform-specific configurations
- Validates setup requirements

### `scripts/wait-for.sh`
- Universal service availability checker
- Multiple fallback methods (nc, telnet, curl, wget)
- Works on any platform with network tools

### `scripts/healthcheck.sh`
- Universal health monitoring
- Multiple detection methods
- Platform-agnostic service checks

### `scripts/jcli-bootstrap.sh`
- Universal Jasmin configuration
- Multiple connection methods
- Idempotent and safe to run multiple times

### `scripts/send-test.sh`
- Universal SMS testing
- Multiple HTTP client support
- Platform-agnostic testing

## 📊 Monitoring Compatibility

### Prometheus
- **Universal Metrics**: Works on any platform
- **Platform Detection**: Automatically configures scraping
- **Resource Monitoring**: Platform-appropriate resource limits

### Grafana
- **Universal Dashboards**: Pre-configured for any platform
- **Auto-Provisioning**: Automatic datasource and dashboard setup
- **Platform Optimization**: Responsive design for any screen size

## 🐳 Docker Compatibility

### Multi-Platform Images
- **Redis**: Official multi-arch image
- **RabbitMQ**: Official multi-arch image
- **Prometheus**: Official multi-arch image
- **Grafana**: Official multi-arch image
- **Jasmin**: linux/amd64 with Apple Silicon compatibility

### Platform-Specific Overrides
- **Apple Silicon**: Uses linux/amd64 for Jasmin
- **ARM64 Linux**: Uses native ARM64 for all services
- **x86_64 Linux**: Uses native x86_64 for all services

## 🔒 Security Considerations

### Platform-Specific Security
- **Apple Silicon**: Secure by default with platform isolation
- **Linux**: Standard Linux security practices
- **Windows**: WSL2 security boundaries
- **Cloud**: Platform-specific security groups and firewalls

### Universal Security Features
- **Default Credentials**: Clearly marked for change
- **Network Isolation**: Docker network security
- **Resource Limits**: Platform-appropriate limits
- **Health Checks**: Comprehensive monitoring

## 🚨 Troubleshooting

### Platform-Specific Issues

#### Apple Silicon Macs
```bash
# Platform warnings are normal
# Jasmin uses linux/amd64 for compatibility
# Other services run natively on ARM64
```

#### ARM64 Linux
```bash
# Ensure Docker supports ARM64
docker run --rm --platform linux/arm64 hello-world
```

#### Windows WSL2
```bash
# Ensure WSL2 is enabled
wsl --set-default-version 2
```

### Universal Troubleshooting

```bash
# Check platform detection
make platform

# Run universal setup
make setup

# Check service status
make status

# View logs
make logs

# Test connectivity
make test
```

## 📈 Performance Optimization

### Platform-Specific Optimizations
- **Apple Silicon**: Balanced compatibility and performance
- **ARM64 Linux**: Native performance with lower resource usage
- **x86_64 Linux**: Maximum performance with native execution
- **Cloud**: Auto-scaling and resource optimization

### Universal Optimizations
- **Resource Limits**: Platform-appropriate CPU and memory limits
- **Health Checks**: Efficient monitoring without overhead
- **Network Optimization**: Optimized for each platform's networking
- **Storage**: Platform-appropriate volume configurations

## 🎯 Production Deployment

### Cloud Platforms
1. **Choose appropriate instance type** for your platform
2. **Run universal setup** to detect and optimize
3. **Configure security groups** for required ports
4. **Set up monitoring** with platform-appropriate dashboards
5. **Configure backups** using platform-specific tools

### On-Premises
1. **Ensure Docker compatibility** with your platform
2. **Run platform detection** to verify compatibility
3. **Configure network access** for required ports
4. **Set up monitoring** and alerting
5. **Implement backup strategy** for your platform

## 📚 Additional Resources

- [Quick Start Guide](docs/QUICKSTART.md)
- [Configuration Guide](docs/CONFIGURATION.md)
- [Monitoring Guide](docs/MONITORING.md)
- [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
- [jCli Recipes](docs/JCLI-RECIPES.md)

## ✅ Compatibility Matrix

| Platform | OS | Architecture | Docker | Compose | Status |
|----------|----|--------------|--------|---------|--------|
| Ubuntu 20.04+ | Linux | x86_64 | ✅ | ✅ | Fully Supported |
| Ubuntu 20.04+ | Linux | ARM64 | ✅ | ✅ | Fully Supported |
| CentOS 8+ | Linux | x86_64 | ✅ | ✅ | Fully Supported |
| RHEL 8+ | Linux | x86_64 | ✅ | ✅ | Fully Supported |
| Debian 11+ | Linux | x86_64 | ✅ | ✅ | Fully Supported |
| Debian 11+ | Linux | ARM64 | ✅ | ✅ | Fully Supported |
| macOS 12+ | macOS | x86_64 | ✅ | ✅ | Fully Supported |
| macOS 12+ | macOS | ARM64 | ✅ | ✅ | Fully Supported |
| Windows 10+ | Windows | x86_64 | ✅ | ✅ | WSL2 Required |
| Windows 11+ | Windows | ARM64 | ✅ | ✅ | WSL2 Required |
| Raspberry Pi OS | Linux | ARM64 | ✅ | ✅ | Fully Supported |
| Raspberry Pi OS | Linux | ARMv7 | ✅ | ✅ | Fully Supported |

This setup truly runs **anywhere** with automatic platform detection and optimization!
