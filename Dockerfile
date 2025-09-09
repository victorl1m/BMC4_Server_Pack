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

# Download ServerStarterJar for NeoForge/Forge compatibility
RUN echo "Downloading ServerStarterJar..." && \
    wget -O server.jar "https://github.com/neoforged/ServerStarterJar/releases/latest/download/server.jar" && \
    echo "ServerStarterJar downloaded successfully"

# Generate user_jvm_args.txt
RUN echo "# Xmx and Xms set the maximum and minimum RAM usage, respectively." > user_jvm_args.txt && \
    echo "# They can take any number, followed by an M or a G." >> user_jvm_args.txt && \
    echo "# M means Megabyte, G means Gigabyte." >> user_jvm_args.txt && \
    echo "# For example, to set the maximum to 3GB: -Xmx3G" >> user_jvm_args.txt && \
    echo "# To set the minimum to 2.5GB: -Xms2500M" >> user_jvm_args.txt && \
    echo "# A good default for a modded server is 4GB." >> user_jvm_args.txt && \
    echo "# Uncomment the next line to set it." >> user_jvm_args.txt && \
    echo "# -Xmx4G" >> user_jvm_args.txt && \
    echo "-Xmx4G -Xms4G -Dlog4j2.formatMsgNoLookups=true -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=100 -XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:G1MixedGCLiveThresholdPercent=35" >> user_jvm_args.txt

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

# Make startup scripts executable
RUN chmod +x /minecraft/start-server.sh /minecraft/debug-server.sh /minecraft/start.sh

# Create necessary directories
RUN mkdir -p /minecraft/world /minecraft/logs /minecraft/crash-reports && \
    chown -R minecraft:minecraft /minecraft

# Switch to minecraft user
USER minecraft

# Expose Minecraft server port
EXPOSE 25565

# Health check - check for server.jar process
HEALTHCHECK --interval=30s --timeout=10s --start-period=180s --retries=3 \
    CMD pgrep -f "server\.jar" > /dev/null || exit 1

# Environment variables
ENV JAVA_OPTS="-Xmx4G -Xms4G -Dlog4j2.formatMsgNoLookups=true -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=100 -XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:G1MixedGCLiveThresholdPercent=35"
ENV EULA=true

# Use the startup script
CMD ["/bin/bash", "/minecraft/start-server.sh"]
