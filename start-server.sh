#!/bin/bash

# Minecraft Forge Server Startup Script for Docker
# This script is optimized for container environments

set -e

echo "Starting Minecraft Forge Server..."
echo "Minecraft Version: 1.20.1"
echo "Forge Version: 47.4.6"

# Accept EULA if not already done
if [ ! -f eula.txt ] || [ "$(cat eula.txt | grep -c 'eula=true')" -eq 0 ]; then
    echo "Accepting Minecraft EULA..."
    echo "eula=true" > eula.txt
fi

# Set default Java options if not provided
if [ -z "$JAVA_OPTS" ]; then
    export JAVA_OPTS="-Xmx4G -Xms4G -Dlog4j2.formatMsgNoLookups=true"
fi

echo "Java Options: $JAVA_OPTS"

# Find the Forge server jar
FORGE_JAR=""
if [ -f forge-*-shim.jar ]; then
    FORGE_JAR=$(ls forge-*-shim.jar | head -n 1)
elif [ -f forge-*.jar ]; then
    FORGE_JAR=$(ls forge-*.jar | grep -v installer | head -n 1)
fi

if [ -z "$FORGE_JAR" ]; then
    echo "ERROR: No Forge server jar found!"
    echo "Available jars:"
    ls -la *.jar 2>/dev/null || echo "No jar files found"
    exit 1
fi

echo "Using Forge jar: $FORGE_JAR"

# Start the server
echo "Starting server with command: java $JAVA_OPTS -jar $FORGE_JAR --nogui"
exec java $JAVA_OPTS -jar "$FORGE_JAR" --nogui
