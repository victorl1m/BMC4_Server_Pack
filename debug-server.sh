#!/bin/bash

# Debug script to check server setup

echo "=== Minecraft Server Debug Information ==="
echo "Date: $(date)"
echo "Working directory: $(pwd)"
echo ""

echo "=== Java Information ==="
java -version
echo ""

echo "=== Available JAR files ==="
ls -la *.jar 2>/dev/null || echo "No jar files found"
echo ""

echo "=== Server files ==="
ls -la server.jar 2>/dev/null || echo "server.jar not found"
ls -la user_jvm_args.txt 2>/dev/null || echo "user_jvm_args.txt not found"
ls -la eula.txt 2>/dev/null || echo "eula.txt not found"
echo ""

echo "=== user_jvm_args.txt content ==="
if [ -f user_jvm_args.txt ]; then
    cat user_jvm_args.txt
else
    echo "user_jvm_args.txt not found"
fi
echo ""

echo "=== Environment Variables ==="
echo "JAVA_OPTS: $JAVA_OPTS"
echo "EULA: $EULA"
echo ""

echo "=== Disk Space ==="
df -h /minecraft
echo ""

echo "=== Memory ==="
free -h
echo ""

echo "=== Network ==="
netstat -tlnp 2>/dev/null || ss -tlnp 2>/dev/null || echo "Network tools not available"
echo ""

echo "=== Process List ==="
ps aux | grep -E "(java|minecraft)" | grep -v grep || echo "No Java/Minecraft processes found"
echo ""
