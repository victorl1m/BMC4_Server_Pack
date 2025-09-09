# Minecraft Server Connection Troubleshooting

If you can't connect to your Minecraft server, follow these steps:

## 1. Check Server Status
Run the debug script inside your container:
```bash
docker exec -it <container_name> /minecraft/debug-server.sh
```

## 2. Check Network Configuration
Run the network test script:
```bash
docker exec -it <container_name> /minecraft/network-test.sh
```

## 3. Common Issues and Solutions

### A. Server not binding to correct IP
**Problem**: Server only binds to localhost inside container
**Solution**: Server should bind to `0.0.0.0:25565`
- Check `server.properties` has `server-ip=0.0.0.0`
- The startup script now automatically fixes this

### B. Docker port mapping issues
**Problem**: Port 25565 not properly exposed
**Solution**: Ensure Docker/Coolify configuration includes:
```yaml
ports:
  - "25565:25565"
```

### C. Firewall/Security Group blocking
**Problem**: Cloud provider firewall blocking port 25565
**Solution**: 
- AWS: Add security group rule for port 25565 TCP
- Google Cloud: Add firewall rule for port 25565
- Azure: Add network security group rule for port 25565
- VPS: Check UFW/iptables rules

### D. Coolify-specific issues
**Problem**: Coolify proxy configuration
**Solution**:
- Ensure the service is configured as "TCP" not "HTTP"
- Check port mapping in Coolify dashboard
- Verify the application is running and healthy

### E. Server still starting up
**Problem**: Server takes time to fully start
**Solution**: 
- Wait 3-5 minutes for full startup
- Check logs: `docker logs <container_name>`
- Forge servers take longer to start than vanilla

## 4. Test Connection Steps

### From same machine as Docker host:
```bash
telnet localhost 25565
# or
nc -zv localhost 25565
```

### From external machine:
```bash
telnet <your_server_ip> 25565
# or
nc -zv <your_server_ip> 25565
```

### Using Minecraft client:
- Add server with IP: `<your_server_ip>:25565`
- If using custom domain, use: `<your_domain>:25565`

## 5. Server Logs
Check server logs for errors:
```bash
docker logs <container_name>
# or
docker exec -it <container_name> tail -f /minecraft/logs/latest.log
```

## 6. Common Error Messages

**"Connection timed out"**: Network/firewall issue
**"Connection refused"**: Server not running or wrong port
**"Outdated client/server"**: Version mismatch
**"Failed to verify username"**: Online mode issue (check `online-mode=true`)

## 7. Quick Fixes

1. **Restart the container**:
   ```bash
   docker restart <container_name>
   ```

2. **Check if server is actually running**:
   ```bash
   docker exec -it <container_name> ps aux | grep java
   ```

3. **Verify port is listening**:
   ```bash
   docker exec -it <container_name> netstat -tlnp | grep 25565
   ```

## 8. Contact Information
If issues persist, provide:
- Output of `debug-server.sh`
- Output of `network-test.sh`
- Docker logs
- Your server's public IP
- How you're trying to connect
