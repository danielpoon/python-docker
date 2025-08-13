FROM python:3.11-slim

# Set working directory dynamically based on USER
ARG USERNAME=defaultuser
WORKDIR /home/${USERNAME}

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    passwd \
    procps \
    uidmap \
    gcc \
    git \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Ensure Python is executable and ready
RUN python3 --version && pip --version && git --version

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command
CMD ["python", "--version"]

