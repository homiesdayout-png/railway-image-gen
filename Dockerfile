FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    python3.11 python3-pip git ffmpeg libsm6 libxext6 \
    && rm -rf /var/lib/apt-get/lists/*

WORKDIR /app
RUN git clone https://github.com/newideas99/ultra-fast-image-gen.git .

RUN pip3 install --no-cache-dir torch torchvision --index-url https://download.pytorch.org/whl/cu121
RUN pip3 install --no-cache-dir diffusers transformers accelerate gradio safetensors huggingface-hub pillow

EXPOSE 7869
ENV FORCE_CUDA="1"
CMD ["python3", "server.py"]
