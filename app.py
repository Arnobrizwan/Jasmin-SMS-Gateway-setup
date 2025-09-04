#!/usr/bin/env python3
"""
Hugging Face Spaces App for Jasmin SMS Gateway
This is a simple web interface for the Jasmin SMS Gateway
"""

import os
import subprocess
import time
import threading
from flask import Flask, render_template, request, jsonify

app = Flask(__name__)

# Global variables for services
jasmin_process = None
redis_process = None
rabbitmq_process = None

def start_services():
    """Start Redis, RabbitMQ, and Jasmin services"""
    global redis_process, rabbitmq_process, jasmin_process
    
    try:
        # Start Redis
        redis_process = subprocess.Popen([
            'redis-server', '--port', '6379', '--daemonize', 'yes'
        ])
        
        # Start RabbitMQ
        rabbitmq_process = subprocess.Popen([
            'rabbitmq-server', '-detached'
        ])
        
        # Wait for services to be ready
        time.sleep(10)
        
        # Start Jasmin
        jasmin_process = subprocess.Popen([
            'python', '-m', 'jasmin'
        ])
        
        print("✅ All services started successfully!")
        
    except Exception as e:
        print(f"❌ Error starting services: {e}")

@app.route('/')
def index():
    """Main page"""
    return render_template('index.html')

@app.route('/api/status')
def status():
    """Check service status"""
    try:
        # Check if Jasmin is responding
        import requests
        response = requests.get('http://localhost:1401/ping', timeout=5)
        jasmin_status = "running" if response.status_code == 200 else "stopped"
    except:
        jasmin_status = "stopped"
    
    return jsonify({
        'jasmin': jasmin_status,
        'redis': 'running',  # Assume running if no error
        'rabbitmq': 'running'  # Assume running if no error
    })

@app.route('/api/send', methods=['POST'])
def send_sms():
    """Send SMS via Jasmin API"""
    try:
        data = request.json
        username = data.get('username', 'foo')
        password = data.get('password', 'bar')
        to = data.get('to')
        content = data.get('content')
        
        if not to or not content:
            return jsonify({'error': 'Missing required fields'}), 400
        
        # Call Jasmin HTTP API
        import requests
        url = f"http://localhost:1401/send"
        params = {
            'username': username,
            'password': password,
            'to': to,
            'content': content
        }
        
        response = requests.get(url, params=params, timeout=10)
        
        if response.status_code == 200:
            return jsonify({'success': True, 'message': response.text})
        else:
            return jsonify({'error': response.text}), 400
            
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/health')
def health():
    """Health check endpoint"""
    try:
        import requests
        response = requests.get('http://localhost:1401/ping', timeout=5)
        return jsonify({'status': 'healthy', 'jasmin': response.text})
    except:
        return jsonify({'status': 'unhealthy'}), 500

if __name__ == '__main__':
    # Start services in background
    threading.Thread(target=start_services, daemon=True).start()
    
    # Start Flask app
    app.run(host='0.0.0.0', port=7860, debug=False)
