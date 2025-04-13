FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Installation des dépendances système
RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    libgl1 \
    libglib2.0-0 \
    python3-pip \
    python3-venv \
    ffmpeg \
    build-essential \
    pkg-config \
    libffi-dev \
    libcairo2-dev \
    libgdk-pixbuf2.0-dev \
    libpango1.0-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configuration Python et création d'un environnement virtuel
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Mettre à jour pip
RUN pip install --no-cache-dir --upgrade pip

# Installation des dépendances Python
RUN pip install --no-cache-dir \
    torch==2.0.1+cu118 \
    torchvision==0.15.2+cu118 \
    xformers==0.0.20 \
    --extra-index-url https://download.pytorch.org/whl/cu118

# Création de la structure des dossiers
RUN mkdir -p /workspace/models/Stable-diffusion \
    /workspace/models/VAE \
    /workspace/models/Lora \
    /workspace/models/ControlNet \
    /workspace/models/embeddings \
    /workspace/outputs \
    /workspace/scripts \
    /workspace/extensions \
    /workspace/repositories

WORKDIR /workspace

# Clonage du dépôt AUTOMATIC1111 Web UI
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git /workspace/stable-diffusion-webui

# Installation des extensions
WORKDIR /workspace/stable-diffusion-webui/extensions
RUN git clone https://github.com/Bing-su/adetailer.git \
    && git clone https://github.com/civitai/sd_civitai_extension.git \
    && git clone https://github.com/zanllp/sd-webui-infinite-image-browsing.git \
    && git clone https://github.com/fkunn1326/openpose-editor.git \
    && git clone https://github.com/forestliurui/sd-webui-controlnet.git \
    && git clone https://github.com/hako-mikan/sd-webui-lora-block-weight.git

# Dépôt AnimateDiff
RUN git clone https://github.com/continue-revolution/sd-webui-animatediff.git

# Copie des scripts
COPY startup.sh /workspace/
COPY app.py /workspace/
COPY webui.py /workspace/stable-diffusion-webui/webui.py

# Rendre le script de démarrage exécutable
RUN chmod +x /workspace/startup.sh

# Installation des dépendances spécifiques pour les extensions
WORKDIR /workspace/stable-diffusion-webui
RUN pip install -r requirements.txt \
    && pip install -r extensions/sd-webui-controlnet/requirements.txt \
    && pip install -r extensions/adetailer/requirements.txt \
    && pip install -r extensions/sd-webui-animatediff/requirements.txt

# Exposer le port pour l'interface web
EXPOSE 7860

# Script de démarrage
CMD ["/workspace/startup.sh"]
