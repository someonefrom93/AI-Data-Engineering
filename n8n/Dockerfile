# Use the official n8n image as the base
FROM n8nio/n8n:latest

# Switch to the root user to install packages
USER root

# Install Python3 and pip if they aren't already present.
# Also install any compiler tools needed for building Python packages.
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-venv && \
    apt-get install -y build-essential

# Switch back to the node user (n8n's default user)
USER node

# Install the required Python packages into the system Python
# The '--user' flag installs them in the user directory, avoiding permission issues.
RUN pip3 install --user pandas duckdb

# Optional: Verify the installations work
RUN python3 -c "import duckdb; print('DuckDB installed successfully')"
RUN python3 -c "import pandas; print('Pandas installed successfully')"