FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04

# Install Python and system dependencies
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3-pip \
    git \
    ffmpeg \
    libsm6 \
    libxext6 \
    && rm -rf /var/lib/apt-get/lists/*

WORKDIR /app

# Clone ultra-fast-image-gen repo
RUN git clone https://github.com/newideas99/ultra-fast-image-gen.git .

# Install PyTorch with CUDA 12.1 support and standard repo requirements
RUN pip3 install --no-cache-dir torch torchvision --index-url https://download.pytorch.org/whl/cu121
RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 7869

# Force CUDA execution and launch server
ENV FORCE_CUDA="1"
CMD ["python3", "server.py"]
