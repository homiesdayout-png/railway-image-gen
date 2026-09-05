FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    python3.11 \
    python3-pip \
    git \
    ffmpeg \
    libsm6 \
    libxext6 \
    && rm -rf /var/lib/apt-get/lists/*

WORKDIR /app

RUN git clone https://github.com/newideas99/ultra-fast-image-gen.git .

# Upgrade build essentials
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel

# Install CUDA PyTorch binary explicitly
RUN pip3 install --no-cache-dir torch torchvision --index-url https://download.pytorch.org/whl/cu121

# Install all explicit dependencies required for FLUX, SDXL, and Qwen execution
RUN pip3 install --no-cache-dir \
    diffusers \
    transformers \
    accelerate \
    safetensors \
    huggingface-hub \
    sentencepiece \
    protobuf \
    gradio \
    pillow \
    opencv-python-headless \
    einops \
    ftfy

# Fallback install for any remaining requirements
RUN pip3 install --no-cache-dir -r requirements.txt || true

EXPOSE 7869

ENV FORCE_CUDA="1"
CMD ["python3", "server.py"]
