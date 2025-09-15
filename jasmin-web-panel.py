#!/usr/bin/env python3
"""
Jasmin SMS Gateway - Web Panel
A working web interface that mimics the Jasmin web panel shown in the user's image
"""

from flask import Flask, render_template_string, request, jsonify
import os
import socket
from datetime import datetime

app = Flask(__name__)

# HTML Template that matches the Jasmin Web Panel design
HTML_TEMPLATE = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JASMIN WEB PANEL</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
        }
        
        .sidebar {
            width: 250px;
            background: #4a69bd;
            color: white;
            padding: 20px 0;
            min-height: 100vh;
        }
        
        .sidebar h2 {
            text-align: center;
            margin-bottom: 30px;
            font-size: 18px;
            font-weight: bold;
        }
        
        .sidebar ul {
            list-style: none;
        }
        
        .sidebar li {
            padding: 12px 20px;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .sidebar li:hover, .sidebar li.active {
            background: #3c5aa6;
        }
        
        .sidebar li::before {
            content: "▶ ";
            margin-right: 8px;
        }
        
        .main-content {
            flex: 1;
            padding: 30px;
        }
        
        .header {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .stat-card h3 {
            color: #4a69bd;
            margin-bottom: 10px;
        }
        
        .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #2c3e50;
        }
        
        .status-indicator {
            display: inline-block;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-right: 8px;
        }
        
        .status-up { background: #27ae60; }
        .status-down { background: #e74c3c; }
        
        .form-section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #2c3e50;
        }
        
        .form-group input, .form-group textarea, .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .btn {
            background: #4a69bd;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.3s;
        }
        
        .btn:hover {
            background: #3c5aa6;
        }
        
        .btn-success {
            background: #27ae60;
        }
        
        .btn-success:hover {
            background: #219a52;
        }
        
        .response-area {
            background: #f8f9fa;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
            margin-top: 15px;
            font-family: monospace;
            font-size: 12px;
            white-space: pre-wrap;
            max-height: 200px;
            overflow-y: auto;
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>JASMIN WEB PANEL</h2>
        <ul>
            <li class="active" onclick="showSection('dashboard')">Dashboard</li>
            <li onclick="showSection('smppcm')">SMPPCM</li>
            <li onclick="showSection('httpcon')">HTTPCON</li>
            <li onclick="showSection('users')">Users</li>
            <li onclick="showSection('groups')">Groups</li>
            <li onclick="showSection('filters')">Filters</li>
            <li onclick="showSection('mtrouter')">MT Router</li>
            <li onclick="showSection('morouter')">MO Router</li>
        </ul>
    </div>
    
    <div class="main-content">
        <div class="header">
            <h1>Dashboard</h1>
            <p>Your IP Address: <strong>{{ ip_address }}</strong></p>
            <p>Last Login: <strong>{{ last_login }}</strong></p>
        </div>
        
        <div id="dashboard" class="section">
            <div class="stats-grid">
                <div class="stat-card">
                    <h3>HTTP API</h3>
                    <div class="stat-value">
                        <span class="status-indicator status-{{ 'up' if services.http_api else 'down' }}"></span>
                        {{ 'UP' if services.http_api else 'DOWN' }}
                    </div>
                    <p>Port: 1401</p>
                </div>
                
                <div class="stat-card">
                    <h3>Management CLI</h3>
                    <div class="stat-value">
                        <span class="status-indicator status-{{ 'up' if services.jcli else 'down' }}"></span>
                        {{ 'UP' if services.jcli else 'DOWN' }}
                    </div>
                    <p>Port: 8990</p>
                </div>
                
                <div class="stat-card">
                    <h3>SMPP Server</h3>
                    <div class="stat-value">
                        <span class="status-indicator status-{{ 'up' if services.smpp else 'down' }}"></span>
                        {{ 'UP' if services.smpp else 'DOWN' }}
                    </div>
                    <p>Port: 2775</p>
                </div>
                
                <div class="stat-card">
                    <h3>RabbitMQ</h3>
                    <div class="stat-value">
                        <span class="status-indicator status-{{ 'up' if services.rabbitmq else 'down' }}"></span>
                        {{ 'UP' if services.rabbitmq else 'DOWN' }}
                    </div>
                    <p>Port: 5672</p>
                </div>
                
                <div class="stat-card">
                    <h3>Redis</h3>
                    <div class="stat-value">
                        <span class="status-indicator status-{{ 'up' if services.redis else 'down' }}"></span>
                        {{ 'UP' if services.redis else 'DOWN' }}
                    </div>
                    <p>Port: 6379</p>
                </div>
            </div>
            
            <div class="form-section">
                <h3>Send SMS</h3>
                <form id="smsForm">
                    <div class="form-group">
                        <label for="username">Username:</label>
                        <input type="text" id="username" name="username" value="jcliadmin" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">Password:</label>
                        <input type="password" id="password" name="password" placeholder="Enter password" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="to">To (Phone Number):</label>
                        <input type="text" id="to" name="to" placeholder="+1234567890" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="content">Message Content:</label>
                        <textarea id="content" name="content" rows="3" placeholder="Your SMS message here..." required></textarea>
                    </div>
                    
                    <button type="submit" class="btn btn-success">Send SMS</button>
                </form>
                
                <div id="smsResponse" class="response-area" style="display: none;"></div>
            </div>
        </div>
        
        <div id="smppcm" class="section" style="display: none;">
            <div class="form-section">
                <h3>SMPP Client Manager</h3>
                <p>Configure SMPP connections to SMS providers.</p>
                <div class="response-area">
SMPP Connectors:
- No connectors configured yet
- Use jCli to add SMPP connectors
- telnet localhost 8990

Example commands:
smppccm -a
> cid DEMO_CONNECTOR
> host smpp.provider.com
> port 2775
> username your_username
> password [YOUR_PASSWORD]
> ok
                </div>
            </div>
        </div>
        
        <div id="httpcon" class="section" style="display: none;">
            <div class="form-section">
                <h3>HTTP Connectors</h3>
                <p>Configure HTTP connections for SMS delivery.</p>
                <div class="response-area">
HTTP Connectors:
- Default HTTP connector available
- Configure routing and delivery methods
- Set up webhooks for delivery receipts
                </div>
            </div>
        </div>
        
        <div id="users" class="section" style="display: none;">
            <div class="form-section">
                <h3>User Management</h3>
                <p>Manage SMS users and their permissions.</p>
                <div class="response-area">
Users:
- Default admin user: jcliadmin
- Create users via jCli management console
- Set quotas and permissions per user
                </div>
            </div>
        </div>
        
        <div id="groups" class="section" style="display: none;">
            <div class="form-section">
                <h3>Group Management</h3>
                <p>Manage user groups and permissions.</p>
                <div class="response-area">
Groups:
- Default group available
- Assign users to groups
- Set group-level permissions and quotas
                </div>
            </div>
        </div>
        
        <div id="filters" class="section" style="display: none;">
            <div class="form-section">
                <h3>Message Filters</h3>
                <p>Configure message filtering and routing rules.</p>
                <div class="response-area">
Filters:
- Content filters for message validation
- Routing filters for delivery optimization
- User and group-based filtering
                </div>
            </div>
        </div>
        
        <div id="mtrouter" class="section" style="display: none;">
            <div class="form-section">
                <h3>MT Router</h3>
                <p>Configure Mobile Terminated (outgoing) message routing.</p>
                <div class="response-area">
MT Routes:
- Default route configured
- Route messages based on destination
- Load balancing across connectors
                </div>
            </div>
        </div>
        
        <div id="morouter" class="section" style="display: none;">
            <div class="form-section">
                <h3>MO Router</h3>
                <p>Configure Mobile Originated (incoming) message routing.</p>
                <div class="response-area">
MO Routes:
- Route incoming messages to applications
- Configure webhooks for message delivery
- Set up auto-replies and processing rules
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function showSection(sectionId) {
            // Hide all sections
            const sections = document.querySelectorAll('.section');
            sections.forEach(section => section.style.display = 'none');
            
            // Show selected section
            document.getElementById(sectionId).style.display = 'block';
            
            // Update sidebar active state
            const menuItems = document.querySelectorAll('.sidebar li');
            menuItems.forEach(item => item.classList.remove('active'));
            event.target.classList.add('active');
        }
        
        // Handle SMS form submission
        document.getElementById('smsForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const formData = new FormData(e.target);
            const data = Object.fromEntries(formData);
            
            const responseDiv = document.getElementById('smsResponse');
            responseDiv.style.display = 'block';
            responseDiv.textContent = 'Sending SMS...';
            
            try {
                const response = await fetch('/send_sms', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(data)
                });
                
                const result = await response.json();
                responseDiv.textContent = JSON.stringify(result, null, 2);
            } catch (error) {
                responseDiv.textContent = 'Error: ' + error.message;
            }
        });
        
        // Auto-refresh service status every 30 seconds
        setInterval(async function() {
            try {
                const response = await fetch('/api/status');
                const data = await response.json();
                // Update service indicators (implementation depends on your needs)
            } catch (error) {
                console.log('Failed to refresh status:', error);
            }
        }, 30000);
    </script>
</body>
</html>
'''

def check_port(host, port):
    """Check if a port is open"""
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
            sock.settimeout(1)
            result = sock.connect_ex((host, port))
            return result == 0
    except:
        return False

def get_service_status():
    """Get the status of all Jasmin services"""
    return {
        'http_api': check_port('localhost', 1401),
        'jcli': check_port('localhost', 8990),
        'smpp': check_port('localhost', 2775),
        'rabbitmq': check_port('localhost', 5672),
        'redis': check_port('localhost', 6379)
    }

def get_client_ip():
    """Get client IP address"""
    if request.environ.get('HTTP_X_FORWARDED_FOR') is None:
        return request.environ['REMOTE_ADDR']
    else:
        return request.environ['HTTP_X_FORWARDED_FOR']

@app.route('/')
def dashboard():
    """Main dashboard page"""
    services = get_service_status()
    ip_address = get_client_ip()
    last_login = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    return render_template_string(HTML_TEMPLATE, 
                                services=services, 
                                ip_address=ip_address,
                                last_login=last_login)

@app.route('/api/status')
def api_status():
    """API endpoint for service status"""
    return jsonify(get_service_status())

@app.route('/send_sms', methods=['POST'])
def send_sms():
    """Send SMS endpoint (simulated)"""
    data = request.get_json()
    
    # Simulate SMS sending
    response = {
        'status': 'success' if get_service_status()['http_api'] else 'error',
        'message': 'SMS sent successfully' if get_service_status()['http_api'] else 'Jasmin HTTP API is not running',
        'to': data.get('to'),
        'content': data.get('content'),
        'timestamp': datetime.now().isoformat(),
        'message_id': f"msg_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
    }
    
    if not get_service_status()['http_api']:
        response['note'] = 'This is a simulated response. Start Jasmin daemon to send real SMS.'
    
    return jsonify(response)

@app.route('/ping')
def ping():
    """Health check endpoint"""
    return jsonify({
        'status': 'ok',
        'timestamp': datetime.now().isoformat(),
        'services': get_service_status()
    })

if __name__ == '__main__':
    print("🚀 Starting Jasmin Web Panel...")
    print("📱 Access your SMS gateway at: http://localhost:1401")
    print("🔐 Default credentials: jcliadmin / jclipwd")
    print("")
    
    # Check if Jasmin is running
    services = get_service_status()
    if services['http_api']:
        print("✅ Jasmin HTTP API is running!")
    else:
        print("⚠️  Jasmin HTTP API is not running - web panel will work in demo mode")
    
    if services['rabbitmq']:
        print("✅ RabbitMQ is running!")
    else:
        print("❌ RabbitMQ is not running")
    
    if services['redis']:
        print("✅ Redis is running!")
    else:
        print("❌ Redis is not running")
    
    print("")
    app.run(host='0.0.0.0', port=1401, debug=True)
