#!/usr/bin/env python3
"""
CORS Proxy for SMS Gateway Dashboard
This allows the dashboard to make requests to the remote SMS Gateway
"""

import http.server
import socketserver
import urllib.request
import urllib.parse
import json
from urllib.error import URLError

class CORSProxyHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        # Check if this is a proxy request
        if self.path.startswith('/proxy/'):
            self.handle_proxy_request()
        else:
            # Serve static files normally
            super().do_GET()
    
    def handle_proxy_request(self):
        try:
            # Extract the target URL from the path
            target_path = self.path[7:]  # Remove '/proxy/' prefix
            target_url = f"http://34.56.36.182:1401/{target_path}"
            
            # Add query parameters
            if '?' in self.path:
                query_part = self.path.split('?')[1]
                target_url += f"?{query_part}"
            
            print(f"Proxying request to: {target_url}")
            
            # Make the request to the target server
            with urllib.request.urlopen(target_url) as response:
                content = response.read()
                
                # Set CORS headers
                self.send_response(200)
                self.send_header('Access-Control-Allow-Origin', '*')
                self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
                self.send_header('Access-Control-Allow-Headers', 'Content-Type')
                self.send_header('Content-Type', response.headers.get('Content-Type', 'text/plain'))
                self.end_headers()
                
                self.wfile.write(content)
                
        except URLError as e:
            self.send_error(502, f"Bad Gateway: {e}")
        except Exception as e:
            self.send_error(500, f"Internal Server Error: {e}")
    
    def do_OPTIONS(self):
        # Handle preflight requests
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()

def serve_with_cors_proxy(port=8081):
    """Serve the dashboard with CORS proxy on the specified port"""
    
    try:
        with socketserver.TCPServer(("", port), CORSProxyHandler) as httpd:
            print(f"🚀 SMS Gateway Dashboard with CORS Proxy")
            print(f"📱 Dashboard URL: http://localhost:{port}/dashboard.html")
            print(f"🔗 Proxy endpoint: http://localhost:{port}/proxy/")
            print(f"⏹️  Press Ctrl+C to stop")
            print("-" * 50)
            
            # Open browser automatically
            import webbrowser
            webbrowser.open(f'http://localhost:{port}/dashboard.html')
            
            # Start serving
            httpd.serve_forever()
            
    except KeyboardInterrupt:
        print("\n🛑 Server stopped by user")
    except OSError as e:
        if e.errno == 48:  # Address already in use
            print(f"❌ Error: Port {port} is already in use!")
            print(f"💡 Try a different port: python3 cors-proxy.py {port + 1}")
        else:
            print(f"❌ Error: {e}")
    except Exception as e:
        print(f"❌ Unexpected error: {e}")

if __name__ == "__main__":
    import sys
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8081
    serve_with_cors_proxy(port)
