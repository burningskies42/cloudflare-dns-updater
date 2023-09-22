# Cloudflare DNS Record Updater
small bash script packed in a container to check whether the ip of the host was changed. When change detected the DNS A record will be updated to the current ip.

## Requirements
The container requires 2 environment variables:
- ZONE_ID
- API_TOKEN

## Example docker-Compose.yaml
```yaml
version: "3"
services:
  dns_updater:
    image: cloudflare_dns_updater
    container_name: cloudflare_dns_updater
    init: true
    environment:
      - ZONE_ID=${ZONE_ID}
      - API_TOKEN=${API_TOKEN}
    restart: unless-stopped
```