# Use the custom FEniCS Docker image
FROM stnb/fenics:latest

# Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Ensure running as root to avoid permission issues
USER root

# Create necessary directories and set permissions
RUN mkdir -p /var/lib/apt/lists/partial && chmod -R 777 /var/lib/apt/lists

# Update system and install system dependencies including tools for building from source
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

# Set the working directory in the Docker container
WORKDIR /app

# Upgrade pip and install basic Python dependencies including setuptools
RUN pip3 install --upgrade pip setuptools scikit-build

# Copy the source code of ideep4py into the Docker container
COPY ideep4py /app/ideep4py

# Install ideep4py from source
RUN cd /app/ideep4py && \
    git submodule update --init && \
    mkdir build && cd build && \
    cmake .. && \
    cd ../python && \
    python3 setup.py install

# Install other Python dependencies from requirements.txt
COPY requirements.txt /app/
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy your FEniCS application code into the Docker container
COPY . /app

# Set the default command to run when starting the container
CMD ["python3", "my_inherentstrain_draft.py"]
