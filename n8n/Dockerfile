# Use the official n8n image as the base (It's Alpine Linux)
FROM n8nio/n8n:latest

# Switch to the root user to install packages
USER root

# Install Python3, pip, and virtual environment using Alpine's package manager (apk)
# Also install build essentials (gcc, musl-dev, etc.) for compiling Python packages
RUN apk update && \
    apk add --no-cache \
        python3 \
        py3-pip \
        python3-dev \
        gcc \
        musl-dev \
        linux-headers

# Switch back to the node user (n8n's default user)
USER node

# Install the required Python packages into the user directory
RUN pip3 install --user pandas duckdb

# Optional: Verify the installations work
RUN python3 -c "import duckdb; print('DuckDB installed successfully')"
RUN python3 -c "import pandas; print('Pandas installed successfully')"