# Use an official Python base image
FROM python:3.10-slim

# Environment settings
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies required for dlib, OpenCV
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    libopenblas-dev \
    liblapack-dev \
    libboost-all-dev \
    libjpeg-dev \
    libpng-dev \
    pkg-config \
    libgtk2.0-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libx11-6 \
    libsm6 \
    libxext6 \
    git \
    wget \
    curl \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --upgrade pip setuptools wheel

# Copy requirements first for caching
COPY requirements.txt /app/requirements.txt
WORKDIR /app

# Install Python dependencies (this will compile dlib)
RUN pip install --no-cache-dir -r requirements.txt

# Copy application source code
COPY . /app

# Expose Flask port
EXPOSE 5000

# Production server using gunicorn
CMD ["gunicorn", "app:app", "-b", "0.0.0.0:5000", "--workers", "1"]
