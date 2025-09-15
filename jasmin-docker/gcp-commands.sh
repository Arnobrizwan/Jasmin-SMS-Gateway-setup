#!/bin/bash
# Google Cloud Platform commands for Jasmin SMS Gateway

echo "☁️  Google Cloud Platform Commands"
echo "=================================="

echo "📋 Prerequisites:"
echo "1. Enable billing on your Google Cloud project"
echo "2. Enable Compute Engine API"
echo ""

echo "🔧 gcloud Commands:"
echo ""

echo "# Set project (replace with your project ID):"
echo "gcloud config set project YOUR_PROJECT_ID"
echo ""

echo "# Enable required APIs:"
echo "gcloud services enable compute.googleapis.com"
echo "gcloud services enable cloudresourcemanager.googleapis.com"
echo ""

echo "# Create VM instance:"
echo "gcloud compute instances create jasmin-sms-gateway \\"
echo "  --zone=us-central1-a \\"
echo "  --machine-type=e2-micro \\"
echo "  --image-family=ubuntu-2204-lts \\"
echo "  --image-project=ubuntu-os-cloud \\"
echo "  --tags=http-server,https-server \\"
echo "  --metadata=startup-script='#!/bin/bash"
echo "apt-get update"
echo "apt-get install -y curl"
echo "curl -s https://raw.githubusercontent.com/Arnobrizwan/Jasmin-SMS-Gateway-setup/main/jasmin-docker/deploy-gcp.sh | bash'"
echo ""

echo "# Create firewall rules:"
echo "gcloud compute firewall-rules create jasmin-sms-gateway \\"
echo "  --allow tcp:22,tcp:1401,tcp:8990,tcp:2775,tcp:15672 \\"
echo "  --source-ranges 0.0.0.0/0 \\"
echo "  --target-tags jasmin-sms-gateway"
echo ""

echo "# Connect to VM:"
echo "gcloud compute ssh jasmin-sms-gateway --zone=us-central1-a"
echo ""

echo "# Get VM external IP:"
echo "gcloud compute instances describe jasmin-sms-gateway --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'"
echo ""

echo "# Delete VM (when done):"
echo "gcloud compute instances delete jasmin-sms-gateway --zone=us-central1-a"
echo ""

echo "📱 After deployment, access your SMS gateway at:"
echo "HTTP API: http://YOUR_VM_EXTERNAL_IP:1401"
echo "Management CLI: telnet YOUR_VM_EXTERNAL_IP 8990"
echo "SMPP Server: YOUR_VM_EXTERNAL_IP:2775"
echo "RabbitMQ Management: http://YOUR_VM_EXTERNAL_IP:15672"
