# Use the official Ubuntu base image
FROM ubuntu:20.04

# Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required system dependencies for FEniCS and other libraries
RUN apt-get update && \
    apt-get install -y \
    software-properties-common \
    wget \
    python3-pip \
    python3-dev \
    libboost-dev \
    libopenmpi-dev \
    libmshr-dev \
    libscotch-dev \
    git \
    cmake \
    petsc-dev \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install scikit-build (aka scikit-build)
RUN pip3 install --upgrade pip && \
    pip3 install scikit-build

# Install Python dependencies from requirements.txt
COPY requirements.txt /app/
RUN pip3 install --no-cache-dir -r /app/requirements.txt

# Install sympy (required for some parts of FEniCS)
RUN pip3 install --no-cache-dir --upgrade sympy

# Install spaCy model (if you have en-core-web-sm in requirements)
RUN python3 -m spacy download en-core-web-sm

# Set the working directory to /app
WORKDIR /app

# Copy all files to /app in the container
COPY . /app

# Default command to run the Python script
CMD ["python3", "my_inherentstrain_draft.py"]
