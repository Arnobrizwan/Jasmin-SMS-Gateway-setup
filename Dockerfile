# Hugging Face Spaces deployment Dockerfile for Jasmin SMS Gateway
FROM jookies/jasmin:latest

# Install additional tools
USER root
RUN apt-get update && apt-get install -y \
    curl \
    netcat \
    redis-tools \
    && rm -rf /var/lib/apt/lists/*

# Create logs directory
RUN mkdir -p /var/log/jasmin

# Set environment variables for Hugging Face Spaces
ENV REDIS_CLIENT_HOST=localhost
ENV AMQP_BROKER_HOST=localhost
ENV JASMIN_HTTP_PORT=1401
ENV JASMIN_JCLI_PORT=8990
ENV JASMIN_SMPP_PORT=2775

# Expose ports
EXPOSE 1401 8990 2775

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:1401/ping || exit 1

# Start Jasmin
CMD ["python", "-m", "jasmin"]
