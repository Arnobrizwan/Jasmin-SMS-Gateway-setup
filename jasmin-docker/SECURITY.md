# Security Guide

## 🔒 Security Overview

This document outlines security best practices for the Jasmin SMS Gateway Ubuntu installation.

## ⚠️ Critical Security Notes

### **NEVER COMMIT SENSITIVE FILES**
- **`.env` files** contain passwords and should never be committed
- **Configuration files** with hardcoded credentials are prohibited
- **Log files** may contain sensitive information

### **Default Behavior**
- All passwords are **generated randomly** during installation
- Credentials are saved in `/etc/jasmin/.env` with restricted permissions (600)
- No hardcoded passwords in the codebase

## 🔐 Password Management

### **Generated Passwords**
During installation, the following passwords are generated:
- **Jasmin HTTP API** password
- **Jasmin Management CLI** password  
- **RabbitMQ Management** password

### **Password Storage**
```bash
# Passwords are stored in:
/etc/jasmin/.env

# File permissions:
chmod 600 /etc/jasmin/.env
chown jasmin:jasmin /etc/jasmin/.env
```

### **Changing Passwords**
```bash
# Edit the environment file
sudo nano /etc/jasmin/.env

# Update passwords
JASMIN_HTTP_PASSWORD=your_new_password
JASMIN_CLI_PASSWORD=your_new_password
RABBITMQ_PASSWORD=your_new_password

# Restart services
sudo systemctl restart jasmind
sudo systemctl restart rabbitmq-server
```

## 🛡️ Security Hardening

### **1. File Permissions**
```bash
# Secure configuration files
sudo chmod 600 /etc/jasmin/.env
sudo chmod 644 /etc/jasmin/jasmin.cfg
sudo chmod 755 /etc/jasmin/
sudo chmod 755 /var/log/jasmin/

# Set proper ownership
sudo chown -R jasmin:jasmin /etc/jasmin
sudo chown -R jasmin:jasmin /var/log/jasmin
```

### **2. Firewall Configuration**
```bash
# Install UFW
sudo apt install ufw

# Allow only necessary ports
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 1401/tcp  # HTTP API (restrict to specific IPs)
sudo ufw allow 8990/tcp  # Management CLI (restrict to specific IPs)
sudo ufw allow 2775/tcp  # SMPP Server (restrict to specific IPs)
sudo ufw allow 15672/tcp # RabbitMQ Management (restrict to specific IPs)

# Enable firewall
sudo ufw enable
```

### **3. Fail2Ban Setup**
```bash
# Install fail2ban
sudo apt install fail2ban

# Create Jasmin jail
sudo tee /etc/fail2ban/jail.d/jasmin.conf > /dev/null <<EOF
[jasmin-http]
enabled = true
port = 1401
filter = jasmin-http
logpath = /var/log/jasmin/messages.log
maxretry = 5
bantime = 3600

[jasmin-cli]
enabled = true
port = 8990
filter = jasmin-cli
logpath = /var/log/jasmin/jasmin.log
maxretry = 3
bantime = 7200
EOF

# Start fail2ban
sudo systemctl start fail2ban
sudo systemctl enable fail2ban
```

### **4. SSL/TLS Configuration**
```bash
# Install nginx for HTTPS termination
sudo apt install nginx certbot python3-certbot-nginx

# Create SSL certificate
sudo certbot --nginx -d your-domain.com

# Configure nginx reverse proxy
sudo tee /etc/nginx/sites-available/jasmin > /dev/null <<EOF
server {
    listen 443 ssl;
    server_name your-domain.com;
    
    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
    
    location / {
        proxy_pass http://localhost:1401;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/jasmin /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## 🔍 Monitoring and Auditing

### **Log Monitoring**
```bash
# Monitor authentication attempts
sudo tail -f /var/log/jasmin/jasmin.log | grep -i "auth\|login\|fail"

# Monitor HTTP API access
sudo tail -f /var/log/jasmin/messages.log | grep -i "http"

# Monitor system logs
sudo journalctl -u jasmind -f
```

### **Security Auditing**
```bash
# Check for failed login attempts
sudo grep -i "fail\|denied\|refused" /var/log/jasmin/*.log

# Check file permissions
find /etc/jasmin -type f -exec ls -la {} \;

# Check open ports
sudo netstat -tlnp | grep -E ":(1401|8990|2775|15672)"

# Check running processes
ps aux | grep jasmin
```

## 🚨 Incident Response

### **Suspected Compromise**
1. **Immediately change all passwords**
2. **Check logs for suspicious activity**
3. **Review file permissions**
4. **Update all packages**
5. **Restart all services**
6. **Monitor for ongoing threats**

### **Password Reset**
```bash
# Reset Jasmin passwords
sudo nano /etc/jasmin/.env
# Update passwords and restart services

# Reset RabbitMQ password
sudo rabbitmqctl change_password admin new_password

# Reset system passwords
sudo passwd jasmin
```

## 📋 Security Checklist

### **Installation**
- [ ] All passwords generated randomly
- [ ] No hardcoded credentials in code
- [ ] Proper file permissions set
- [ ] Services running as non-root user

### **Post-Installation**
- [ ] Change all default passwords
- [ ] Configure firewall rules
- [ ] Enable fail2ban
- [ ] Set up SSL/TLS
- [ ] Configure log monitoring
- [ ] Regular security updates

### **Ongoing Maintenance**
- [ ] Regular password rotation
- [ ] Monitor logs daily
- [ ] Update packages weekly
- [ ] Security audits monthly
- [ ] Backup configurations securely

## 📞 Security Contacts

- **Security Issues**: Create a GitHub issue with "security" label
- **Critical Vulnerabilities**: Contact maintainers directly
- **General Security Questions**: Use GitHub discussions

## 📚 Additional Resources

- [Ubuntu Security Guide](https://ubuntu.com/security)
- [Jasmin Security Documentation](https://docs.jasminsms.com/)
- [OWASP Security Guidelines](https://owasp.org/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

---

**Remember: Security is an ongoing process, not a one-time setup!**
