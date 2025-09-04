# Jasmin SMS Gateway Setup

A complete setup for Jasmin SMS Gateway with monitoring dashboard and CORS proxy support.

## 🚀 Quick Start

1. **Navigate to the setup directory:**
   ```bash
   cd jasmin-docker
   ```

2. **Start the monitoring dashboard:**
   ```bash
   python3 cors-proxy.py 8081
   ```

3. **Access the dashboard:**
   - Open: `http://localhost:8081/dashboard.html`
   - Monitor your SMS Gateway in real-time

## 📁 Project Structure

```
jasmin-docker/
├── dashboard.html          # Real-time monitoring dashboard
├── cors-proxy.py          # CORS proxy for remote gateway access
├── README.md              # Detailed setup instructions
├── install-ubuntu.sh      # Ubuntu installation script
├── deploy-gcp.sh          # Google Cloud deployment script
└── ...                    # Other configuration files
```

## 🌐 Live SMS Gateway

- **URL**: `http://34.56.36.182:1401`
- **Status**: ✅ Active and Working
- **Dashboard**: Real-time monitoring available

## 📚 Documentation

For detailed setup instructions, API reference, and troubleshooting, see:
- **[jasmin-docker/README.md](jasmin-docker/README.md)** - Complete setup guide
- **[jasmin-docker/GCP-DEPLOY.md](jasmin-docker/GCP-DEPLOY.md)** - Google Cloud deployment
- **[jasmin-docker/SECURITY.md](jasmin-docker/SECURITY.md)** - Security guidelines

## 🎯 Features

- ✅ **Real-time Dashboard** with CORS proxy support
- ✅ **SMS Gateway** running on Google Cloud
- ✅ **HTTP API** for sending SMS messages
- ✅ **Authentication** system
- ✅ **Message tracking** with unique IDs
- ✅ **Monitoring** and health checks
- ✅ **Troubleshooting** guides

## 🔧 Usage

### Send SMS via API
```bash
curl "http://34.56.36.182:1401/send?username=admin&password=PASSWORD&to=+1234567890&content=Hello%20World"
```

### Check Gateway Status
```bash
curl "http://34.56.36.182:1401/ping"
```

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/Arnobrizwan/Jasmin-SMS-Gateway-setup/issues)
- **Documentation**: [jasmin-docker/README.md](jasmin-docker/README.md)

---

**Made with ❤️ by the Jasmin SMS Gateway community**