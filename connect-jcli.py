#!/usr/bin/env python3
"""
Simple script to connect to Jasmin Management CLI
Alternative to telnet when telnet is not available
"""

import socket
import sys
import time

def connect_to_jcli(host='localhost', port=8990):
    """Connect to Jasmin Management CLI"""
    try:
        # Create socket
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(10)
        
        # Connect
        print(f"Connecting to {host}:{port}...")
        sock.connect((host, port))
        print("✅ Connected successfully!")
        print("=" * 50)
        
        # Read initial response
        response = sock.recv(1024).decode('utf-8')
        print(response)
        
        # Interactive mode
        print("\n🔧 Interactive mode (type 'quit' to exit)")
        print("=" * 50)
        
        while True:
            try:
                # Get user input
                command = input("jcli : ").strip()
                
                if command.lower() in ['quit', 'exit', 'q']:
                    break
                
                if command:
                    # Send command
                    sock.send((command + '\n').encode('utf-8'))
                    
                    # Read response
                    response = sock.recv(4096).decode('utf-8')
                    if response:
                        print(response)
                        
            except KeyboardInterrupt:
                print("\n\nExiting...")
                break
            except Exception as e:
                print(f"Error: {e}")
                break
                
    except ConnectionRefusedError:
        print("❌ Connection refused. Make sure Jasmin is running.")
        print("Try: docker-compose ps")
    except socket.timeout:
        print("❌ Connection timeout. Check if the service is running.")
    except Exception as e:
        print(f"❌ Error: {e}")
    finally:
        try:
            sock.close()
        except:
            pass

if __name__ == "__main__":
    connect_to_jcli()
