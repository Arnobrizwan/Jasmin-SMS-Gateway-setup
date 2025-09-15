#!/usr/bin/env python3
"""
Simple SMS Gateway API Test
This creates a minimal HTTP API to test SMS functionality locally
"""

from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import urllib.parse
import uuid
from datetime import datetime
import threading
import time

class SMSGatewayHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path.startswith('/ping'):
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'pong')
            
        elif self.path.startswith('/status'):
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            status = {
                "status": "online",
                "service": "SMS Gateway Test",
                "timestamp": datetime.now().isoformat(),
                "version": "1.0.0"
            }
            self.wfile.write(json.dumps(status).encode())
            
        elif self.path.startswith('/send'):
            # Parse query parameters
            query = urllib.parse.urlparse(self.path).query
            params = urllib.parse.parse_qs(query)
            
            username = params.get('username', [''])[0]
            password = params.get('password', [''])[0]
            to = params.get('to', [''])[0]
            content = params.get('content', [''])[0]
            
            # Simple authentication (for testing)
            if username == 'admin' and password == 'admin123':
                message_id = str(uuid.uuid4())
                response = {
                    "status": "success",
                    "message_id": message_id,
                    "to": to,
                    "content": content,
                    "timestamp": datetime.now().isoformat()
                }
                
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps(response).encode())
                
                print(f"📱 SMS Sent: {to} - {content} (ID: {message_id})")
            else:
                response = {
                    "status": "error",
                    "message": "Authentication failed"
                }
                
                self.send_response(401)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps(response).encode())
        else:
            self.send_response(404)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'Not Found')
    
    def log_message(self, format, *args):
        print(f"🌐 {datetime.now().strftime('%H:%M:%S')} - {format % args}")

def start_server():
    server = HTTPServer(('localhost', 1401), SMSGatewayHandler)
    print("🚀 SMS Gateway Test Server Starting...")
    print("📱 HTTP API: http://localhost:1401")
    print("🔧 Endpoints:")
    print("  - GET /ping - Health check")
    print("  - GET /status - Service status")
    print("  - GET /send?username=admin&password=admin123&to=PHONE&content=MESSAGE - Send SMS")
    print("")
    print("🧪 Test commands:")
    print("  curl http://localhost:1401/ping")
    print("  curl http://localhost:1401/status")
    print('  curl "http://localhost:1401/send?username=admin&password=admin123&to=+1234567890&content=Hello%20World"')
    print("")
    print("Press Ctrl+C to stop the server")
    print("=" * 50)
    
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n🛑 Server stopped")
        server.shutdown()

if __name__ == "__main__":
    start_server()
