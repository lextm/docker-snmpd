# Use a minimal Alpine image
FROM alpine:3.14

# Metadata
LABEL maintainer="support@lextudio.com"
LABEL description="Docker image for running snmpd (Net-SNMP Daemon)"
LABEL version="1.0"

# Install snmpd and bash for debugging
RUN apk add --no-cache net-snmp bash

# Copy custom snmpd configuration if available
COPY snmpd.conf /etc/snmp/snmpd.conf

# Expose SNMP UDP port
EXPOSE 161/udp

# Create a non-root user (optional)
RUN adduser -D -H -s /bin/false snmpuser

# Ensure the snmpuser has access to the configuration file
RUN chown snmpuser:snmpuser /etc/snmp/snmpd.conf

# Run snmpd as a non-root user
USER snmpuser

# Run snmpd in the foreground (-f) with logging to stderr (-Le)
CMD ["/usr/sbin/snmpd", "-f", "-Le"]

# Optional: Add a health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s \
  CMD pgrep snmpd || exit 1
