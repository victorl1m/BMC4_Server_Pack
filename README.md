# Minecraft Forge Server - Coolify Deployment

This is a Dockerized Minecraft Forge server (v1.20.1) optimized for deployment on Coolify.

## Quick Deploy on Coolify

1. **Create a new service** in your Coolify dashboard
2. **Connect your Git repository** containing this server pack
3. **Set the service type** to "Docker"
4. **Configure the following settings**:
   - Port: `25565`
   - Environment variables:
     ```
     EULA=true
     JAVA_OPTS=-Xmx4G -Xms4G -Dlog4j2.formatMsgNoLookups=true
     ```

## Features

- ✅ **Optimized Docker build** with multi-stage build process
- ✅ **Automatic Forge installation** if not present
- ✅ **Security hardened** (runs as non-root user)
- ✅ **Health checks** included
- ✅ **Persistent storage** for world and logs
- ✅ **Memory optimized** with proper JVM flags
- ✅ **Coolify ready** with proper port exposure

## Memory Requirements

- **Minimum**: 4GB RAM allocated to container
- **Recommended**: 6-8GB RAM for optimal performance
- **CPU**: 2+ cores recommended

## Server Configuration

The server is pre-configured with:
- **Minecraft Version**: 1.20.1
- **Forge Version**: 47.4.6
- **Default Memory**: 4GB (configurable via JAVA_OPTS)
- **Port**: 25565

## Volumes

- `/minecraft/world` - World save data
- `/minecraft/logs` - Server logs

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `EULA` | `true` | Accept Minecraft EULA |
| `JAVA_OPTS` | `-Xmx4G -Xms4G -Dlog4j2.formatMsgNoLookups=true` | JVM options |

## Deployment Instructions

### Method 1: Direct Deploy (Recommended)

1. Fork/clone this repository
2. In Coolify, create a new service
3. Connect your Git repository
4. Deploy!

### Method 2: Manual Docker Build

```bash
# Build the image
docker build -t minecraft-forge-server .

# Run the container
docker run -d \
  --name minecraft-server \
  -p 25565:25565 \
  -e EULA=true \
  -v minecraft_world:/minecraft/world \
  -v minecraft_logs:/minecraft/logs \
  minecraft-forge-server
```

## Server Management

### Accessing Server Console

```bash
# Using Coolify dashboard console feature
# Or using Docker:
docker exec -it minecraft-server /bin/bash
```

### Viewing Logs

```bash
# Using Coolify logs viewer
# Or using Docker:
docker logs minecraft-server
```

### Backup World Data

The world data is stored in the `minecraft_world` volume. Coolify provides backup features for persistent volumes.

## Troubleshooting

### Server Won't Start

1. Check if EULA is accepted: ensure `EULA=true` environment variable is set
2. Verify memory allocation: ensure at least 4GB is available
3. Check logs for specific error messages

### Performance Issues

1. Increase memory allocation via `JAVA_OPTS`
2. Ensure adequate CPU resources
3. Monitor disk I/O for world storage

### Port Issues

- Ensure port 25565 is properly exposed in Coolify
- Check firewall settings if applicable

## Optimization Notes

- Server uses OpenJDK 21 for best performance
- Multi-stage Docker build reduces image size
- Non-root user execution for security
- Proper Java garbage collection flags included

## Support

For server-specific issues, refer to the Forge and mod documentation. For deployment issues, check Coolify documentation or logs.
