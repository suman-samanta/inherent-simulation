# Use the custom FEniCS Docker image
FROM stnb/fenics:latest

# Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Ensure running as root to avoid permission issues
USER root

# Create necessary directories and set permissions
RUN mkdir -p /var/lib/apt/lists/partial && chmod -R 777 /var/lib/apt/lists

# Update system and install system dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libopenmpi-dev \
    libeigen3-dev \
    wget \
    curl \
    git \
    python3-dev \
    python3-pip \
    libhdf5-serial-dev \
    libblas-dev \
    liblapack-dev \
    gdal-bin \
    libgdal-dev \
    cmake && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set GDAL environment variables
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

# Set the working directory
WORKDIR /app

# Upgrade pip & setuptools, and install ideep4py
RUN pip3 install --upgrade pip setuptools && \
    pip3 install ideep4py

# Copy your app and requirements
COPY requirements.txt /app/
COPY . /app

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Set default command
CMD ["python3", "my_inherentstrain_draft.py"]
