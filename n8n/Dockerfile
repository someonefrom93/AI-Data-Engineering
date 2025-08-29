# Use the official n8n image
FROM n8nio/n8n:latest

# Switch to root to install Python (minimal install)
USER root

# Install only Python3 (csv module is included in standard library)
RUN apk update && \
    apk add --no-cache python3

# Switch back to the node user
USER node

# Verify Python is working
RUN python3 --version