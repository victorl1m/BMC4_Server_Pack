#!/bin/bash

# Minecraft Forge Server Startup Script for Docker
# This script is optimized for container environments using ServerStarterJar

set -e

echo "Starting Minecraft Forge Server..."
echo "Minecraft Version: 1.20.1"
echo "Forge Version: 47.4.6"
echo "Java Options: $JAVA_OPTS"

# Accept EULA if not already done
if [ ! -f eula.txt ] || [ "$(cat eula.txt | grep -c 'eula=true')" -eq 0 ]; then
    echo "Accepting Minecraft EULA..."
    echo "eula=true" > eula.txt
fi

# Check for ServerStarterJar
if [ ! -f server.jar ]; then
    echo "ERROR: No server.jar found!"
    echo "Available files:"
    ls -la *.jar 2>/dev/null || echo "No jar files found"
    exit 1
fi

echo "Using ServerStarterJar: server.jar"

# Define the Forge installer URL for ServerStarterJar
FORGE_INSTALLER_URL="https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.4.6/forge-1.20.1-47.4.6-installer.jar"

# Start the server using ServerStarterJar with Forge installer
echo "Starting server with ServerStarterJar..."
echo "Command: java @user_jvm_args.txt -Djava.security.manager=allow -jar server.jar --installer-force --installer $FORGE_INSTALLER_URL nogui"
exec java @user_jvm_args.txt -Djava.security.manager=allow -jar server.jar --installer-force --installer "$FORGE_INSTALLER_URL" nogui
