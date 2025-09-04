# Deploy from Terminal - Step by Step

## 🚀 **Method 1: Using Git + Web Interface (Recommended)**

### Step 1: Push to GitHub
```bash
# Add remote repository (replace with your GitHub repo)
git remote add origin https://github.com/yourusername/your-repo.git

# Push to GitHub
git push -u origin main
```

### Step 2: Deploy via Web Interface
1. Open browser: https://render.com
2. Sign up/Login with GitHub
3. Click "New +" → "Blueprint"
4. Select your repository
5. Render will auto-detect `render.yaml`
6. Click "Apply" to deploy

## 🚀 **Method 2: Using Render CLI (If Available)**

### Step 1: Install Render CLI
```bash
# Try one of these methods:
npm install -g @render/cli
# OR
brew install render
# OR
curl -fsSL https://cli.render.com/install | sh
```

### Step 2: Login and Deploy
```bash
# Login to Render
render auth login

# Deploy using render.yaml
render services create --file render.yaml
```

## 🚀 **Method 3: Manual Service Creation**

### Step 1: Create Services Manually
```bash
# Create Jasmin service
render services create \
  --name jasmin-sms-gateway \
  --type web \
  --env docker \
  --dockerfilePath ./Dockerfile.render \
  --plan starter \
  --region oregon

# Create Redis service
render services create \
  --name jasmin-redis \
  --type redis \
  --plan starter \
  --region oregon

# Create RabbitMQ service
render services create \
  --name jasmin-rabbitmq \
  --type web \
  --env docker \
  --dockerfilePath ./Dockerfile.rabbitmq \
  --plan starter \
  --region oregon
```

## 📱 **After Deployment**

Your SMS gateway will be available at:
- **HTTP API**: `https://your-service-name.onrender.com`
- **Management CLI**: `telnet your-service-name.onrender.com 8990`
- **SMPP Server**: `your-service-name.onrender.com:2775`

## 🔧 **Quick Commands**

```bash
# Check deployment status
render services list

# View logs
render logs --service jasmin-sms-gateway

# Update service
render services update jasmin-sms-gateway

# Delete service
render services delete jasmin-sms-gateway
```

## 🆘 **Troubleshooting**

### If CLI Installation Fails
- Use **Method 1** (Git + Web Interface)
- It's actually easier and more reliable

### If Services Don't Start
- Check logs in Render dashboard
- Verify environment variables
- Check resource limits

### If Can't Connect
- Wait 5-10 minutes for full deployment
- Check service URLs in dashboard
- Verify firewall settings

---

**Ready to deploy? Choose your method and follow the steps!** 🚀
