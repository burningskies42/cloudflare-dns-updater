# Use a minimal Alpine Linux base image
FROM alpine:latest

# Install curl and cron
RUN apk --no-cache add curl
RUN apk --no-cache add dcron
RUN apk --no-cache add jq

# Copy your script into the container
COPY update_dns.sh /usr/local/bin/update_dns.sh

# Set execute permissions on the script
RUN chmod +x /usr/local/bin/update_dns.sh

# Start the cron daemon in the background
CMD ["/usr/local/bin/update_dns.sh"]
