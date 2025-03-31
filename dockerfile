# Use the custom FEniCS Docker image
FROM stnb/fenics:latest

# Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Ensure running as root to avoid permission issues
USER root

# Create necessary directories and set permissions
RUN mkdir -p /var/lib/apt/lists/partial && chmod -R 777 /var/lib/apt/lists

# Update system and install system dependencies including CMake and Python 3.8 dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libopenmpi-dev \
    libeigen3-dev \
    wget \
    curl \
    git \
    python3.8-dev \
    python3-pip \
    libhdf5-serial-dev \
    libblas-dev \
    liblapack-dev \
    gdal-bin \
    libgdal-dev \
    libomp-dev \
    cmake && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set GDAL environment variables
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

# Set the working directory in the Docker container
WORKDIR /app


# Copy the requirements.txt file to the container
COPY requirements.txt /app/

# Upgrade pip, install scikit-build, and install Python dependencies
RUN pip3 install --upgrade pip && \
    pip3 install scikit-build && \
    pip3 install --no-cache-dir -r requirements.txt

# Copy your FEniCS application code into the Docker container
COPY . /app

# Set the default command to run when starting the container
CMD ["python3", "my_inherentstrain_draft.py"]
