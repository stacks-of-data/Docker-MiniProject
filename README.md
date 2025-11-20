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
```

### View Packets Data
```bash
wireshark ./logger/captures/tcpdump.pcap
```

### View Captured Requests
```bash
tail -f ./proxy/log/mitmdump.log
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
- **Logging**: Captures all HTTP/HTTPS traffic to `./proxy/log/mitmdump.log`

### tcpdump Service
- **Image**: Debian with Chromium
- **Logging**: Captures all packets data to `./logger/captures/tcpdump.pcap`

## Configuration

### Change Target URL

Edit `docker-compose.yml`:

```yaml
services:
  browser:
    command: https://suspicious-site.com
```

### Change DNS Servers

Edit `docker-compose.yml`:

```yaml
dns:
  - 1.1.1.1        # Cloudflare
  - 1.0.0.1
```

## Cleanup

Remove all containers, images, and logs:

```bash
./cleanup.sh
```

Manual cleanup:

```bash
docker compose down --rmi all
rm -rf ./proxy/log
rm -rf ./logger/captures
```

## Future Enhancements

- [ ] Add ClamAV malware scanning
- [ ] Add Firefox alternative container
- [ ] Add tcpdump service for packet capture
- [ ] Web dashboard for traffic visualization
- [ ] Automated threat detection

## License

MIT License - See [LICENSE](LICENSE) file for details
