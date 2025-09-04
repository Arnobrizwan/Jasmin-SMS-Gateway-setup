# Free Hosting Deployment Guide

This guide shows you how to deploy the Jasmin SMS Gateway to various free hosting platforms.

## 🚀 Quick Deploy Options

### 1. Railway.app (Recommended)
**Best for**: Docker-based deployments, easy setup
**Free tier**: $5 credit monthly, 500 hours runtime

```bash
# One-click deploy
./scripts/deploy-railway.sh
```

**Manual steps:**
1. Go to [Railway.app](https://railway.app)
2. Sign up with GitHub
3. Click "New Project" → "Deploy from GitHub repo"
4. Select your repository
5. Railway will automatically detect the Dockerfile and deploy

### 2. Render.com
**Best for**: Simple deployments, good free tier
**Free tier**: 750 hours/month, sleeps after 15 minutes

```bash
# Get deployment instructions
./scripts/deploy-render.sh
```

**Manual steps:**
1. Go to [Render.com](https://render.com)
2. Sign up with GitHub
3. Click "New +" → "Web Service"
4. Connect your repository
5. Configure:
   - **Name**: jasmin-sms-gateway
   - **Environment**: Docker
   - **Dockerfile Path**: `./Dockerfile.render`
   - **Plan**: Free

### 3. Fly.io
**Best for**: Global deployment, good performance
**Free tier**: 3 shared-cpu-1x VMs, 160GB outbound data

```bash
# Deploy with CLI
./scripts/deploy-fly.sh
```

**Manual steps:**
1. Install Fly CLI: `curl -L https://fly.io/install.sh | sh`
2. Run `fly auth login`
3. Run `fly launch` in your project directory
4. Follow the prompts

### 4. Heroku
**Best for**: Traditional PaaS, easy scaling
**Free tier**: Discontinued, but paid plans available

```bash
# Deploy with CLI
./scripts/deploy-heroku.sh
```

**Manual steps:**
1. Install Heroku CLI
2. Run `heroku login`
3. Run `heroku create your-app-name`
4. Run `git push heroku main`

## 📋 Pre-Deployment Checklist

### 1. Environment Variables
Make sure to set these environment variables on your hosting platform:

```bash
# Core settings
JASMIN_HTTP_PORT=1401
JASMIN_JCLI_PORT=8990
JASMIN_SMPP_PORT=2775
RABBITMQ_MGMT_PORT=15692

# Security (CHANGE THESE!)
HTTP_TEST_USERNAME=admin
HTTP_TEST_PASSWORD=your_secure_password
GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=your_secure_password

# Internal networking
REDIS_HOST=redis
RABBITMQ_HOST=rabbitmq

# Public URL (update with your actual URL)
PUBLIC_BASE_URL=https://your-app-name.railway.app
```

### 2. Port Configuration
Different platforms use different ports:

| Platform | HTTP Port | Notes |
|----------|-----------|-------|
| Railway.app | 1401 | Uses custom port |
| Render.com | 10000 | Fixed port for free tier |
| Fly.io | 8080 | Configurable |
| Heroku | $PORT | Dynamic port |

### 3. Resource Limits
Free tiers have limitations:

| Platform | CPU | Memory | Storage | Network |
|----------|-----|--------|---------|---------|
| Railway.app | 1 vCPU | 1GB | 1GB | Unlimited |
| Render.com | 0.5 vCPU | 512MB | 1GB | 100GB/month |
| Fly.io | 0.5 vCPU | 256MB | 3GB | 160GB/month |
| Heroku | 0.5 vCPU | 512MB | 1GB | 2TB/month |

## 🔧 Platform-Specific Configurations

### Railway.app
- **File**: `railway.json`
- **Dockerfile**: `Dockerfile.railway`
- **Features**: Automatic HTTPS, custom domains, persistent volumes

### Render.com
- **File**: `render.yaml`
- **Dockerfile**: `Dockerfile.render`
- **Features**: Auto-deploy, health checks, custom domains

### Fly.io
- **File**: `fly.toml`
- **Dockerfile**: `Dockerfile.fly`
- **Features**: Global edge deployment, custom domains, metrics

### Heroku
- **File**: `heroku.yml`
- **Dockerfile**: `Dockerfile.heroku`
- **Features**: Add-ons, scaling, monitoring

## 🚀 Deployment Steps

### Step 1: Prepare Your Repository
```bash
# Make sure all files are committed
git add .
git commit -m "Prepare for deployment"
git push origin main
```

### Step 2: Choose Your Platform
Pick one of the platforms above based on your needs:
- **Railway.app**: Best overall experience
- **Render.com**: Simplest setup
- **Fly.io**: Best performance
- **Heroku**: Most features

### Step 3: Deploy
Follow the platform-specific instructions above.

### Step 4: Configure
1. Set environment variables
2. Update `PUBLIC_BASE_URL` with your actual URL
3. Change default passwords
4. Configure custom domain (optional)

### Step 5: Test
```bash
# Test your deployment
curl https://your-app-name.railway.app/health

# Test SMS sending
curl -X POST https://your-app-name.railway.app/send \
  -d "username=admin&password=your_password&to=1234567890&content=Hello World"
```

## 🔒 Security Considerations

### 1. Change Default Passwords
```bash
# Generate secure passwords
openssl rand -base64 32
```

### 2. Use Environment Variables
Never hardcode passwords in your code. Use environment variables instead.

### 3. Enable HTTPS
All platforms provide HTTPS by default. Make sure to use HTTPS URLs.

### 4. Restrict Access
Consider using IP whitelisting or authentication for admin interfaces.

## 📊 Monitoring Your Deployment

### 1. Health Checks
All platforms support health checks. The app exposes:
- `/health` - Basic health check
- `/ping` - Simple ping endpoint

### 2. Logs
Access logs through your platform's dashboard:
- **Railway.app**: Built-in log viewer
- **Render.com**: Logs tab in dashboard
- **Fly.io**: `fly logs`
- **Heroku**: `heroku logs --tail`

### 3. Metrics
Monitor resource usage:
- CPU usage
- Memory usage
- Network traffic
- Response times

## 🛠️ Troubleshooting

### Common Issues

#### 1. Port Conflicts
```bash
# Check if ports are available
netstat -tulpn | grep :1401
```

#### 2. Memory Issues
```bash
# Check memory usage
docker stats
```

#### 3. Network Issues
```bash
# Test connectivity
curl -v https://your-app-url.com/health
```

#### 4. Database Issues
```bash
# Check Redis connection
docker exec -it jasmin-redis redis-cli ping

# Check RabbitMQ
docker exec -it jasmin-rabbitmq rabbitmq-diagnostics ping
```

### Platform-Specific Issues

#### Railway.app
- **Issue**: App not starting
- **Solution**: Check logs in Railway dashboard

#### Render.com
- **Issue**: App sleeping
- **Solution**: Upgrade to paid plan or use external ping service

#### Fly.io
- **Issue**: Region not available
- **Solution**: Change region in `fly.toml`

#### Heroku
- **Issue**: Dyno sleeping
- **Solution**: Upgrade to paid plan or use external ping service

## 📚 Additional Resources

- [Railway.app Documentation](https://docs.railway.app)
- [Render.com Documentation](https://render.com/docs)
- [Fly.io Documentation](https://fly.io/docs)
- [Heroku Documentation](https://devcenter.heroku.com)

## 🎯 Production Considerations

### 1. Upgrade to Paid Plans
Free tiers have limitations. Consider upgrading for:
- Better performance
- More resources
- No sleep mode
- Custom domains
- SSL certificates

### 2. Use External Databases
For production, consider using:
- **Redis**: Redis Cloud, AWS ElastiCache
- **RabbitMQ**: CloudAMQP, AWS MQ

### 3. Implement Monitoring
- Set up alerts for downtime
- Monitor resource usage
- Track SMS delivery rates
- Monitor error rates

### 4. Backup Strategy
- Regular database backups
- Configuration backups
- Log retention policies

## 🚀 Quick Start Commands

```bash
# Deploy to Railway.app
./scripts/deploy-railway.sh

# Deploy to Render.com
./scripts/deploy-render.sh

# Deploy to Fly.io
./scripts/deploy-fly.sh

# Deploy to Heroku
./scripts/deploy-heroku.sh
```

Choose your platform and start deploying! 🎉
