# Multi-stage build for better optimization
FROM openjdk:21-jdk-slim AS builder

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /minecraft

# Copy server files
COPY . .

# Download and install Forge server if not present
RUN if [ ! -f forge-*.jar ] || [ ! -f forge-*-shim.jar ]; then \
        echo "Downloading Forge installer..."; \
        wget -O forge-installer.jar "https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.4.6/forge-1.20.1-47.4.6-installer.jar"; \
        echo "Installing Forge server..."; \
        java -jar forge-installer.jar --installServer; \
        rm -f forge-installer.jar; \
    fi

# Production stage
FROM openjdk:21-jdk-slim

LABEL maintainer="Minecraft Server"
LABEL description="Minecraft Forge Server 1.20.1 for Coolify"

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Create minecraft user for security
RUN useradd -m -u 1000 minecraft

# Create working directory
WORKDIR /minecraft

# Copy built server from builder stage
COPY --from=builder /minecraft /minecraft

# Make startup script executable
RUN chmod +x /minecraft/start-server.sh

# Create necessary directories
RUN mkdir -p /minecraft/world /minecraft/logs /minecraft/crash-reports && \
    chown -R minecraft:minecraft /minecraft

# Switch to minecraft user
USER minecraft

# Expose Minecraft server port
EXPOSE 25565

# Health check - simplified for container environment
HEALTHCHECK --interval=30s --timeout=10s --start-period=180s --retries=3 \
    CMD pgrep -f "forge.*jar" > /dev/null || exit 1

# Environment variables
ENV JAVA_OPTS="-Xmx4G -Xms4G -Dlog4j2.formatMsgNoLookups=true -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=100 -XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:G1MixedGCLiveThresholdPercent=35"
ENV EULA=true

# Use the startup script
CMD ["/bin/bash", "/minecraft/start-server.sh"]
