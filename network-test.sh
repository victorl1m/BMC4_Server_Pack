#!/bin/bash

# Network troubleshooting script for Minecraft server in Docker

echo "=== Minecraft Server Network Diagnostics ==="
echo "Date: $(date)"
echo ""

echo "=== Container Network Configuration ==="
echo "Hostname: $(hostname)"
echo "Container IP addresses:"
ip addr show 2>/dev/null || ifconfig 2>/dev/null || echo "Network tools not available"
echo ""

echo "=== Port Status ==="
echo "Checking if port 25565 is listening..."
netstat -tlnp 2>/dev/null | grep :25565 || ss -tlnp 2>/dev/null | grep :25565 || echo "Port 25565 not found listening"
echo ""

echo "=== Server Properties Check ==="
if [ -f server.properties ]; then
    echo "Server IP binding:"
    grep "server-ip=" server.properties || echo "server-ip not found in server.properties"
    echo "Server Port:"
    grep "server-port=" server.properties || echo "server-port not found in server.properties"
    echo "Online Mode:"
    grep "online-mode=" server.properties || echo "online-mode not found in server.properties"
else
    echo "server.properties not found!"
fi
echo ""

echo "=== Java Process Check ==="
ps aux | grep -E "(java|server\.jar)" | grep -v grep || echo "No Java server processes found"
echo ""

echo "=== Recent Server Logs ==="
if [ -f logs/latest.log ]; then
    echo "Last 20 lines of server log:"
    tail -20 logs/latest.log
elif [ -f latest.log ]; then
    echo "Last 20 lines of server log:"
    tail -20 latest.log
else
    echo "No server logs found"
fi
echo ""

echo "=== Environment Variables ==="
echo "JAVA_OPTS: $JAVA_OPTS"
echo "EULA: $EULA"
echo ""

echo "=== Connectivity Test ==="
echo "Testing internal connectivity..."
nc -z -v localhost 25565 2>&1 || echo "Cannot connect to localhost:25565"
nc -z -v 127.0.0.1 25565 2>&1 || echo "Cannot connect to 127.0.0.1:25565"
echo ""

echo "=== Docker Network Info ==="
echo "This container should be accessible on the Docker host at port 25565"
echo "Make sure your Docker host/Coolify instance has port 25565 exposed to the internet"
echo "Check your cloud provider's security groups/firewall rules"
echo ""
