# Use a minimal Alpine Linux base image
FROM alpine:latest

# Install curl and cron
RUN apk update && \
        apk upgrade --available && \
        apk add --no-cache \
        curl dcron jq 

# Copy your script into the container
COPY update_dns.sh /usr/local/bin/update_dns.sh
COPY utils.sh /usr/local/bin/utils.sh

# Set execute permissions on the script
RUN chmod +x /usr/local/bin/update_dns.sh
RUN chmod +x /usr/local/bin/utils.sh

# Start the cron daemon in the background
CMD ["/usr/local/bin/update_dns.sh"]
