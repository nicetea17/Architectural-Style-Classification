# Use a modern, supported base image (Bookworm = Debian 12)
FROM python:3.11-slim-bookworm

# Prevent interactive prompts during package install
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies for Python packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    gcc \
    gfortran \
    build-essential \
    libopenblas-dev \
    liblapack-dev \
    libatlas-base-dev \
    libfreetype6-dev \
    libpng-dev \
    pkg-config \
    libjpeg-dev \
    zlib1g-dev \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --upgrade pip setuptools wheel

# Pre-install numpy (helps with scientific libs)
RUN pip install numpy==1.26.4 --prefer-binary --no-cache-dir

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --prefer-binary -r requirements.txt

# Copy the app
COPY app app/

# Expose Render port (optional for local dev)
EXPOSE 5000

# Start command — use host/port variables
ENV PORT=5000
CMD ["python", "app/server.py"]
