#!/bin/bash

# Coolify Deployment Helper Script
# Run this script on your Coolify server to deploy the Minecraft server

echo "🚀 Minecraft Forge Server - Coolify Deployment Helper"
echo "=================================================="

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed or not in PATH"
    exit 1
fi

echo "✅ Docker is available"

# Build the image
echo "🔨 Building Docker image..."
docker build -t minecraft-forge-coolify .

if [ $? -eq 0 ]; then
    echo "✅ Docker image built successfully"
else
    echo "❌ Failed to build Docker image"
    exit 1
fi

# Test run (optional)
read -p "🤔 Do you want to test run the container? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🧪 Starting test container..."
    docker run -d \
        --name minecraft-test \
        -p 25565:25565 \
        -e EULA=true \
        minecraft-forge-coolify
    
    echo "✅ Test container started. Check with: docker logs minecraft-test"
    echo "🛑 To stop test: docker stop minecraft-test && docker rm minecraft-test"
fi

echo ""
echo "🎉 Deployment ready for Coolify!"
echo ""
echo "📋 Coolify Configuration:"
echo "  - Service Type: Docker"
echo "  - Port: 25565"
echo "  - Environment Variables:"
echo "    EULA=true"
echo "    JAVA_OPTS=-Xmx4G -Xms4G -Dlog4j2.formatMsgNoLookups=true"
echo ""
echo "💾 Recommended Volumes:"
echo "  - /minecraft/world (World data)"
echo "  - /minecraft/logs (Server logs)"
echo ""
echo "⚙️  Resource Requirements:"
echo "  - RAM: 4-8GB"
echo "  - CPU: 2+ cores"
echo "  - Storage: 10GB+ for world data"
