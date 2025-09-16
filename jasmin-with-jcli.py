#!/usr/bin/env python3
"""
Jasmin SMS Gateway with jcli support
This creates a complete SMS gateway with HTTP API and jcli telnet interface
"""

import asyncio
import json
import uuid
import socket
import threading
from datetime import datetime
from http.server import HTTPServer, BaseHTTPRequestHandler
import urllib.parse

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
                "service": "Jasmin SMS Gateway",
                "timestamp": datetime.now().isoformat(),
                "version": "1.0.0",
                "jcli": "enabled"
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
            
            # Authentication
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

class JCLIServer:
    def __init__(self, host='localhost', port=8990):
        self.host = host
        self.port = port
        self.running = False
        
    def handle_client(self, client_socket, address):
        try:
            # Send welcome message
            client_socket.send(b"Authentication required.\r\n")
            client_socket.send(b"Username: ")
            
            # Read username
            username = client_socket.recv(1024).decode().strip()
            client_socket.send(b"Password: ")
            
            # Read password
            password = client_socket.recv(1024).decode().strip()
            
            # Authenticate
            if username == 'admin' and password == 'admin123':
                client_socket.send(b"Welcome to Jasmin 0.11.1 console\r\n")
                client_socket.send(b"Type quit to exit\r\n")
                client_socket.send(b"jcli : ")
                
                # Simple command loop
                while True:
                    command = client_socket.recv(1024).decode().strip()
                    if command.lower() in ['quit', 'exit']:
                        break
                    elif command == 'help':
                        client_socket.send(b"Available commands: help, quit, status\r\n")
                    elif command == 'status':
                        client_socket.send(b"Jasmin SMS Gateway is running\r\n")
                    else:
                        client_socket.send(b"Unknown command. Type 'help' for available commands.\r\n")
                    client_socket.send(b"jcli : ")
            else:
                client_socket.send(b"Authentication failed.\r\n")
                
        except Exception as e:
            print(f"Error handling client: {e}")
        finally:
            client_socket.close()
    
    def start(self):
        server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server_socket.bind((self.host, self.port))
        server_socket.listen(5)
        self.running = True
        
        print(f"🔧 JCLI Server started on {self.host}:{self.port}")
        
        while self.running:
            try:
                client_socket, address = server_socket.accept()
                client_thread = threading.Thread(
                    target=self.handle_client,
                    args=(client_socket, address)
                )
                client_thread.daemon = True
                client_thread.start()
            except Exception as e:
                if self.running:
                    print(f"Error accepting connection: {e}")
        
        server_socket.close()
    
    def stop(self):
        self.running = False

def start_http_server():
    server = HTTPServer(('localhost', 1401), SMSGatewayHandler)
    print("📱 HTTP API Server started on http://localhost:1401")
    server.serve_forever()

def start_jcli_server():
    jcli_server = JCLIServer()
    jcli_server.start()

def main():
    print("🚀 Starting Jasmin SMS Gateway with jcli support...")
    print("📱 HTTP API: http://localhost:1401")
    print("🔧 JCLI: telnet localhost 8990")
    print("")
    print("Press Ctrl+C to stop all services")
    print("=" * 50)
    
    # Start JCLI server in a separate thread
    jcli_thread = threading.Thread(target=start_jcli_server)
    jcli_thread.daemon = True
    jcli_thread.start()
    
    # Start HTTP server in the main thread
    try:
        start_http_server()
    except KeyboardInterrupt:
        print("\n🛑 Server stopped")

if __name__ == "__main__":
    main()
