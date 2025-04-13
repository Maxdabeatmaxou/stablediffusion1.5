FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

ENV TRANSFORMERS_CACHE=/workspace/cache
ENV HF_HOME=/workspace/huggingface

# Clone WebUI
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git .

# Extensions
WORKDIR /workspace/extensions
RUN git clone https://github.com/Bing-su/adetailer.git || true && \
    git clone https://github.com/civitai/sd_civitai_extension.git || true && \
    git clone https://github.com/zanllp/sd-webui-infinite-image-browsing.git || true && \
    git clone https://github.com/fkunn1326/openpose-editor.git || true && \
    git clone https://github.com/Mikubill/sd-webui-controlnet.git || true && \
    git clone https://github.com/hako-mikan/sd-webui-lora-block-weight.git || true

# Téléchargement modèle SD 1.5 (.safetensors)
WORKDIR /workspace/models/Stable-diffusion
RUN wget -O v1-5-pruned-emaonly.safetensors https://civitai.com/api/download/models/125871 || true

# Téléchargement modèle ControlNet
WORKDIR /workspace/models/ControlNet
RUN wget -O control_sd15_canny.pth https://huggingface.co/lllyasviel/ControlNet/resolve/main/models/control_sd15_canny.pth || true

WORKDIR /workspace

EXPOSE 7860

CMD ["python3", "launch.py", "--xformers", "--medvram", "--listen", "--port", "7860", "--enable-insecure-extension-access"]
