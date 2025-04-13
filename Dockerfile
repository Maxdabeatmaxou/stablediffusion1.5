# Base image avec Python, Git, et autres outils utiles
FROM python:3.10-slim

# Installation des dépendances système
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

# Définir un dossier de travail
WORKDIR /workspace

# Cloner AUTOMATIC1111 WebUI
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git .

# Extensions à ajouter
WORKDIR /workspace/extensions

RUN git clone https://github.com/Bing-su/adetailer.git || true && \
    git clone https://github.com/civitai/sd_civitai_extension.git || true && \
    git clone https://github.com/zanllp/sd-webui-infinite-image-browsing.git || true && \
    git clone https://github.com/fkunn1326/openpose-editor.git || true && \
    git clone https://github.com/Mikubill/sd-webui-controlnet.git || true && \
    git clone https://github.com/hako-mikan/sd-webui-lora-block-weight.git || true

# Dossier de lancement
WORKDIR /workspace

CMD ["python3", "launch.py", "--xformers"]