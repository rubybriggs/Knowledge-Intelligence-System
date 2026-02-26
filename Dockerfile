# Use uppercase for consistency to fix the 'FromAsCasing' warning
FROM python:3.10-slim AS builder

# Set working directory
WORKDIR /app

# Install system dependencies required for building packages like chroma-hnswlib
# These are necessary for C++ compilation during the pip install process
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3-dev \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip to the latest version
RUN pip install --no-cache-dir --upgrade pip

# Copy only requirements first to leverage Docker caching
COPY requirements.txt .

# Install dependencies
# Removed the --user flag to ensure packages are accessible in the container's default PATH
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Command to run your application
CMD ["python", "main.py"]