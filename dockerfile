# Use the custom FEniCS Docker image
FROM stnb/fenics:latest

# Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update system and install additional system dependencies that might be necessary
RUN apt-get update && apt-get install -y \
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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the Docker container
WORKDIR /app

# Copy the requirements.txt file to the container
COPY requirements.txt /app/

# Install Python dependencies from requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy your FEniCS application code into the Docker container
COPY . /app

# Set the default command to run when starting the container
CMD ["python3", "my_inherentstrain_draft.py"]
