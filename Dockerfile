# Base image with Python 3.9
FROM python:3.9-slim-buster

# Install system dependencies for Python packages
RUN apt-get update && apt-get install -y \
    git \
    python3-dev \
    gcc \
    build-essential \
    libopenblas-dev \
    liblapack-dev \
    libatlas-base-dev \
    gfortran \
    libfreetype6-dev \
    libpng-dev \
    pkg-config \
    libjpeg-dev \
    zlib1g-dev \
    libffi-dev \
    libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip to the latest version
RUN pip install --upgrade pip

# Install numpy first with a compatible version to avoid build issues
RUN pip install numpy==1.23.5 --prefer-binary --no-cache-dir

# Copy requirements file and install other dependencies
COPY requirements.txt .
RUN pip install --prefer-binary --no-cache-dir -r requirements.txt

# Copy the application files
COPY app app/

# Expose the port used by the server
EXPOSE 5000

# Run the application
CMD ["python", "app/server.py", "serve"]
