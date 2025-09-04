#!/usr/bin/env python3
"""
Simple HTTP server to serve the SMS Gateway Dashboard
"""

import http.server
import socketserver
import webbrowser
import os
import sys
from pathlib import Path

def serve_dashboard(port=8080):
    """Serve the dashboard on the specified port"""
    
    # Change to the directory containing the dashboard
    dashboard_dir = Path(__file__).parent
    os.chdir(dashboard_dir)
    
    # Check if dashboard.html exists
    if not Path('dashboard.html').exists():
        print("❌ Error: dashboard.html not found!")
        return
    
    # Create HTTP server
    handler = http.server.SimpleHTTPRequestHandler
    
    try:
        with socketserver.TCPServer(("", port), handler) as httpd:
            print(f"🚀 SMS Gateway Dashboard Server")
            print(f"📱 Dashboard URL: http://localhost:{port}/dashboard.html")
            print(f"📁 Serving from: {dashboard_dir}")
            print(f"⏹️  Press Ctrl+C to stop")
            print("-" * 50)
            
            # Open browser automatically
            webbrowser.open(f'http://localhost:{port}/dashboard.html')
            
            # Start serving
            httpd.serve_forever()
            
    except KeyboardInterrupt:
        print("\n🛑 Server stopped by user")
    except OSError as e:
        if e.errno == 48:  # Address already in use
            print(f"❌ Error: Port {port} is already in use!")
            print(f"💡 Try a different port: python3 serve-dashboard.py {port + 1}")
        else:
            print(f"❌ Error: {e}")
    except Exception as e:
        print(f"❌ Unexpected error: {e}")

if __name__ == "__main__":
    # Get port from command line argument or use default
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
    serve_dashboard(port)
