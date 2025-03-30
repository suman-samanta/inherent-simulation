# Use the custom FEniCS Docker image
FROM stnb/fenics:latest

# Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Ensure running as root to avoid permission issues
USER root

# Create necessary directories and set permissions
RUN mkdir -p /var/lib/apt/lists/partial && chmod -R 777 /var/lib/apt/lists

# Install required system dependencies for building from source
RUN apt-get update && \
    apt-get install -y \
    software-properties-common \
    build-essential \
    libopenmpi-dev \
    libeigen3-dev \
    wget \
    curl \
    git \
    python3-pip \
    libhdf5-serial-dev \
    libblas-dev \
    liblapack-dev \
    gdal-bin \
    libgdal-dev \
    cmake \
    swig \
    doxygen \
    gcc \
    g++ \
    python3.6-dev \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python 3.6 from deadsnakes repository (required for Python 3.6)
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.6 python3.6-dev python3.6-distutils

# Set GDAL environment variables
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

# Set the working directory
WORKDIR /app

# Upgrade pip and setuptools
RUN pip3 install --upgrade pip setuptools

# Install numpy (specific version required)
RUN pip3 install numpy==1.13

# Install ideep4py from source
RUN git clone https://github.com/IntelPython/ideep4py.git /app/ideep4py && \
    cd /app/ideep4py && \
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
