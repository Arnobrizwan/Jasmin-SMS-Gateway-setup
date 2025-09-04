# Deploy to Render.com

This guide shows you how to deploy your Jasmin SMS Gateway to Render.com for free.

## 🚀 Quick Deploy

### Option 1: Using the Deploy Script
```bash
# Deploy with one command
make deploy-render
```

### Option 2: Using Render CLI
```bash
# Install Render CLI (if not installed)
# Visit: https://render.com/docs/cli

# Login to Render
render auth login

# Deploy
render services create --file render.yaml
```

### Option 3: Using Web Interface
1. Go to [Render.com](https://render.com)
2. Sign up/Login with GitHub
3. Click "New +" → "Blueprint"
4. Connect your GitHub repository
5. Select this repository and branch
6. Render will automatically detect `render.yaml`

## 📋 What Gets Deployed

### Services Created
- **Jasmin SMS Gateway** - Main application (Web service)
- **Redis** - Database for message tracking
- **RabbitMQ** - Message broker

### Configuration
- **Plan**: Starter (Free tier)
- **Region**: Oregon
- **Health Check**: `/ping` endpoint
- **Environment**: Docker

## 🔧 Configuration

### Environment Variables
The following environment variables are automatically set:
- `REDIS_CLIENT_HOST=redis`
- `AMQP_BROKER_HOST=rabbit-mq`
- `JCLI_ADMIN_USER=jcliadmin`
- `JCLI_ADMIN_PASS=jclipwd`

### Custom Domain
After deployment, you can:
1. Go to your service settings
2. Add a custom domain
3. Update DNS records

## 📱 Access Your Gateway

### After Deployment
- **HTTP API**: `https://your-service-name.onrender.com`
- **Management CLI**: `telnet your-service-name.onrender.com 8990`
- **SMPP Server**: `your-service-name.onrender.com:2775`

### Health Check
- **Endpoint**: `https://your-service-name.onrender.com/ping`
- **Response**: `Jasmin/PONG`

## 🔒 Security

### Default Credentials
- **Management CLI**: `jcliadmin` / `jclipwd`
- **RabbitMQ Management**: `admin` / `admin`

### Security Recommendations
1. **Change default passwords** immediately
2. **Use environment variables** for sensitive data
3. **Enable HTTPS** (automatic on Render)
4. **Restrict access** to necessary ports only

## 📊 Monitoring

### Render Dashboard
- View service status
- Check logs
- Monitor resource usage
- Set up alerts

### Health Checks
- Automatic health monitoring
- Auto-restart on failure
- Resource limits enforced

## 🔧 Troubleshooting

### Common Issues

#### Service Won't Start
1. Check logs in Render dashboard
2. Verify environment variables
3. Check resource limits

#### Can't Connect to CLI
1. Verify service is running
2. Check firewall settings
3. Try different port

#### SMS Not Sending
1. Check connector status
2. Verify user configuration
3. Check logs for errors

### Debug Mode
1. Go to Render dashboard
2. Click on your service
3. View logs in real-time
4. Check service metrics

## 💰 Pricing

### Free Tier
- **Jasmin Service**: 750 hours/month
- **Redis**: 1GB storage
- **RabbitMQ**: 750 hours/month
- **Bandwidth**: 100GB/month

### Paid Plans
- **Starter**: $7/month per service
- **Standard**: $25/month per service
- **Pro**: $85/month per service

## 📚 Next Steps

### After Deployment
1. **Configure Users**: Connect to Management CLI
2. **Set Up Routes**: Configure SMS routing
3. **Test SMS**: Send your first SMS
4. **Monitor**: Set up alerts and monitoring

### Production Setup
1. **Upgrade Plan**: Move to paid plan for production
2. **Custom Domain**: Add your own domain
3. **SSL Certificate**: Automatic HTTPS
4. **Backup**: Set up data backup

## 🆘 Support

### Render Support
- **Documentation**: [render.com/docs](https://render.com/docs)
- **Community**: [render.com/community](https://render.com/community)
- **Support**: [render.com/support](https://render.com/support)

### Jasmin Support
- **Documentation**: [docs.jasminsms.com](https://docs.jasminsms.com/)
- **GitHub**: [github.com/jookies/jasmin](https://github.com/jookies/jasmin)

---

**Ready to deploy? Run `make deploy-render` and follow the prompts!** 🚀
