# Web Testing Sandbox

A Docker-based sandbox environment for safely testing and analyzing suspicious websites and links.

## Features

- **Sandboxed Chromium Browser** - Isolated browsing environment
- **HTTPS Traffic Interception** - mitmproxy captures and logs all HTTP/HTTPS traffic
- **Network Traffic Capture** - tcpdump for low-level packet analysis
- **DNS Control** - Custom DNS configuration via docker compose
- **Security Hardening** - Read-only filesystem, no new privileges, temporary filesystems
- **Auto-Cleanup** - Easy cleanup script for fresh builds

## Project Structure

```
sandbox/
├── browser/                 # Chromium container
│   ├── Dockerfile
│   └── entrypoint.sh
├── mitmdump/               # mitmproxy logging container
│   ├── dockerfile
│   └── entrypoint.sh
├── docker-compose.yml      # Service orchestration
├── cleanup.sh              # Clean rebuild script
├── README.md               # This file
└── LICENSE                 # MIT License
```

## Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Linux/macOS (Windows requires WSL2)

### Run the Sandbox

```bash
# Clean build
./cleanup.sh

# Start services
docker compose up

# In another terminal, view logs
docker compose logs -f mitmdump
```

### Test a Website

```bash
docker compose run browser https://example.com
```

### View Captured Traffic

```bash
# View mitmdump logs
tail -f ./mitmdump/log/mitmdump.log

# Analyze with mitmproxy interactive mode (requires X11)
mitmproxy -r ./mitmdump/log/mitmdump.dump
```

## Services

### Browser Service
- **Image**: Debian with Chromium
- **Security Features**:
  - `--no-sandbox` for container compatibility
  - `no-new-privileges` security option
  - Read-only root filesystem
  - Temporary `/tmp` and `/var/tmp` mounts
- **Proxy**: Routes traffic through mitmproxy on port 8080

### mitmproxy Service
- **Image**: Python 3 with mitmproxy
- **Mode**: Regular (non-transparent)
- **Port**: 8080
- **Logging**: Captures all HTTP/HTTPS traffic to `./mitmdump/log/mitmdump.log`

## Configuration

### Change Target URL

Edit `docker-compose.yml`:

```yaml
services:
  browser:
    command: https://suspicious-site.com
```

Or pass at runtime:

```bash
docker compose run browser https://your-url.com
```

### Change DNS Servers

Edit `docker-compose.yml`:

```yaml
dns:
  - 1.1.1.1        # Cloudflare
  - 1.0.0.1
```

### View Network Traffic

```bash
# Monitor tcpdump (requires tcpdump service in docker-compose)
docker exec tcpdump tcpdump -i eth0 -n tcp or udp
```

## Security Notes

⚠️ **This is a sandbox, not a firewall:**
- Malicious websites can still attempt exploitation
- Use only for analysis, not as primary defense
- Keep Docker updated
- Don't run untrusted binaries

## Cleanup

Remove all containers, images, and logs:

```bash
./cleanup.sh
```

Manual cleanup:

```bash
docker compose down --rmi all
docker builder prune --all --force
rm -rf ./mitmdump/log/*
```

## Examples

### Test 1: Normal Website
```bash
docker compose run browser https://example.com
```

### Test 2: Local HTML File
```bash
docker compose run browser file:///tmp/test.html
```

### Test 3: View Captured Requests
```bash
tail -f ./mitmdump/log/mitmdump.log
```

## Troubleshooting

### Browser exits immediately
- Check logs: `docker logs browser`
- Ensure URL is valid and reachable
- Try a simpler site like `https://example.com`

### mitmproxy not logging
- Verify container is running: `docker ps`
- Check volumes are mounted: `docker inspect mitmdump`
- Ensure `/home/mitmdump/log` directory exists

### No network traffic captured
- Verify both containers are on `sandbox-network`
- Check browser is using proxy: `--proxy-server=http://mitmdump:8080`
- Ensure mitmproxy is listening: `docker logs mitmdump`

## Future Enhancements

- [ ] Add ClamAV malware scanning
- [ ] Add Firefox alternative container
- [ ] Add tcpdump service for packet capture
- [ ] Web dashboard for traffic visualization
- [ ] Automated threat detection

## License

MIT License - See [LICENSE](LICENSE) file for details