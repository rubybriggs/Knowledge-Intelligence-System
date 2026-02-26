# Stage 1: Build Stage
FROM python:3.11-slim as builder

WORKDIR /app

# Install system dependencies required to build Rust/C++ extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    & \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Add Rust to the PATH
ENV PATH="/root/.cargo/bin:${PATH}"

COPY requirements.txt .

# Upgrade pip and install dependencies into a local folder
RUN pip install --upgrade pip && \
    pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Production Stage
FROM python:3.11-slim

WORKDIR /app

# Copy only the installed packages from the builder stage
COPY --from=builder /root/.local /root/.local
# Copy your application code
COPY . .

# Ensure the installed packages are in the python path
ENV PATH=/root/.local/bin:$PATH

CMD ["python3", "app.py"]