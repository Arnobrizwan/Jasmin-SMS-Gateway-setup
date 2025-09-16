# Jasmin SMS Gateway - Local Development with Py4Web GUI

A complete setup for Jasmin SMS Gateway with Py4Web GUI for comprehensive management and monitoring.

## 🚀 Features

- **Jasmin SMS Gateway** - Full-featured SMS gateway with HTTP API
- **Py4Web GUI** - Professional web interface for complete Jasmin management
- **Web Panel Dashboard** - Modern web interface for management
- **Local Testing** - Complete local development environment
- **Simple Configuration** - Clean configuration files
- **Easy Setup** - One-command start and test scripts

## 📋 Prerequisites

- Python 3.8+
- Redis Server
- RabbitMQ Server
- Ubuntu 18.04+ (for server deployment)

## 🛠️ Local Installation

### 1. Install Dependencies

```bash
# macOS (using Homebrew)
brew install redis rabbitmq

# Ubuntu/Debian
sudo apt-get update
sudo apt-get install redis-server rabbitmq-server python3 python3-pip
```

### 2. Start Services

```bash
# Start Redis
redis-server

# Start RabbitMQ
rabbitmq-server
```

### 3. Install Jasmin

```bash
pip3 install --pre jasmin
```

### 4. Start Complete System

```bash
# Start Jasmin with Py4Web GUI
./start.sh
```

## 🌐 Management Interfaces

### Py4Web GUI (Recommended)

The Py4Web GUI provides comprehensive management of your Jasmin SMS Gateway:

```bash
./start.sh
```

Access at: `http://localhost:8000/jasmin_smsc_gui`

**Features:**
- Complete user management
- Connector configuration
- Route management
- Statistics and monitoring
- Filter and interceptor management

### Simple Web Panel (Alternative)

The included web panel provides a basic interface for managing your SMS gateway:

```bash
python3 jasmin-web-panel.py
```

Access at: `http://localhost:8080`

## 📡 API Endpoints

- **HTTP API**: `http://localhost:1401`
- **Management CLI**: `telnet localhost 8990`
- **SMPP Server**: `localhost:2775`

### Default Credentials
- Username: `admin`
- Password: `admin123`

## 🧪 Testing

### Test Complete System

```bash
# Test the complete system
./test.sh
```

### Manual Testing

```bash
# Test ping
curl http://localhost:1401/ping

# Test status
curl http://localhost:1401/status

# Test SMS sending
curl "http://localhost:1401/send?username=admin&password=admin123&to=+1234567890&content=Hello%20World"
```

## 📁 Project Structure

```
Jasmin-SMS-Gateway-setup-2/
├── README.md                          # This file
├── jasmin.cfg                        # Main Jasmin configuration
├── jasmin-web-panel.py               # Simple web dashboard
├── jasmin-with-jcli.py               # Jasmin with jcli support
├── start.sh                          # Start script for complete system
├── test.sh                           # Test script for complete system
├── password.txt                      # Py4Web password file
├── py4web.ini                        # Py4Web configuration
├── apps/
│   └── jasmin_smsc_gui/              # Py4Web GUI application
│       ├── settings.py               # GUI configuration
│       ├── controllers.py            # GUI controllers
│       ├── models.py                 # Data models
│       └── templates/                # HTML templates
├── etc/
│   └── resource/
│       └── amqp0-9-1.xml            # AMQP specification file
├── logs/                             # Log files (created at runtime)
└── store/                            # Data storage (created at runtime)
```

## 🔧 Configuration

### Environment Variables

Create a `.env` file with your settings:

```bash
# Jasmin Configuration
JASMIN_HTTP_USERNAME=your_username
JASMIN_HTTP_PASSWORD=your_secure_password
JASMIN_CLI_USERNAME=your_cli_username
JASMIN_CLI_PASSWORD=your_secure_cli_password

# Redis Configuration
REDIS_HOST=localhost
REDIS_PORT=6379

# RabbitMQ Configuration
RABBITMQ_HOST=localhost
RABBITMQ_PORT=5672
RABBITMQ_USERNAME=admin
RABBITMQ_PASSWORD=your_secure_rabbitmq_password
```

## 🧪 Testing

### Test Local Setup

```bash
# Test HTTP API
curl http://localhost:1401/ping

# Test web panel
curl http://localhost:8080

# Test CLI
telnet localhost 8990
```

### Test Server Deployment

```bash
# Test server endpoints
curl http://YOUR_SERVER_IP:1401/ping
curl http://YOUR_SERVER_IP:5000
```

## 📚 Usage Examples

### Send SMS via HTTP API

```bash
curl -X POST http://localhost:1401/send \
  -u jcliadmin:jclipwd \
  -d "to=+1234567890" \
  -d "content=Hello from Jasmin!"
```

### Send SMS via Web Panel

1. Open `http://localhost:8080`
2. Navigate to "Send SMS"
3. Enter recipient and message
4. Click "Send"

## 🔒 Security Notes

- Change default passwords before production use
- Use HTTPS in production
- Configure firewall rules appropriately
- Regular security updates

## 🐛 Troubleshooting

### Common Issues

1. **Jasmin won't start**: Check Redis and RabbitMQ are running
2. **AMQP errors**: Ensure correct AMQP spec file is in place
3. **Permission errors**: Check file permissions and ownership
4. **Port conflicts**: Verify ports 1401, 8990, 2775 are available

### Logs

Check logs in:
- `/var/log/jasmin/` (server)
- `./logs/` (local)

## 📄 License

This project is open source. Please ensure you comply with Jasmin's licensing terms.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

For issues and questions:
- Check the troubleshooting section
- Review Jasmin documentation
- Open an issue in this repository