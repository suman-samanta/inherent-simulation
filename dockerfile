# Use the official FEniCS stable image as the base
FROM fenics/stable:2021.1

# Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install additional system dependencies required for FEniCS and Dolfin
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
    gfortran \
    libblas-dev \
    liblapack-dev \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip3 install --upgrade pip

# Install FEniCS dependencies (specific versions)
RUN pip3 install fenics-dijitso==2019.2.0.dev0 \
    fenics-dolfin==2019.2.0.dev0 \
    fenics-ffc==2019.2.0.dev0 \
    fenics-fiat==2019.2.0.dev0 \
    fenics-ufl==2019.2.0.dev0

# If you have additional Python dependencies in requirements.txt, install them
COPY requirements.txt /app/
RUN pip3 install --no-cache-dir -r /app/requirements.txt

# Install sympy (required for some parts of FEniCS)
RUN pip3 install --no-cache-dir --upgrade sympy

# Install spaCy model (if you have en-core-web-sm in requirements)
RUN python3 -m spacy download en-core-web-sm

# Set the working directory to /app
WORKDIR /app

# Copy the rest of your files to the container
COPY . /app

# Default command to run the Python script (adjust this based on your entry script)
CMD ["python3", "my_inherentstrain_draft.py"]
