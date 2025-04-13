#!/bin/bash
# startup.sh - Script de démarrage pour Stable Diffusion sur RunPod

set -e

echo "🚀 Démarrage de l'environnement Stable Diffusion 1.5"
echo "📁 Vérification et téléchargement des modèles..."

# Fonction pour télécharger un modèle s'il n'existe pas
download_if_not_exists() {
    local url=$1
    local destination=$2
    
    if [ ! -f "$destination" ]; then
        echo "📥 Téléchargement de $(basename "$destination")..."
        wget -q --show-progress "$url" -O "$destination"
        echo "✅ Téléchargement terminé: $(basename "$destination")"
    else
        echo "✅ Le fichier $(basename "$destination") existe déjà."
    fi
}

# Télécharger le modèle Stable Diffusion 1.5 si non présent
SD15_MODEL="/workspace/models/Stable-diffusion/v1-5-pruned-emaonly.safetensors"
SD15_URL="https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors"
download_if_not_exists "$SD15_URL" "$SD15_MODEL"

# Télécharger le VAE amélioré
VAE_MODEL="/workspace/models/VAE/vae-ft-mse-840000-ema-pruned.safetensors"
VAE_URL="https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors"
download_if_not_exists "$VAE_URL" "$VAE_MODEL"

# Télécharger les modèles ControlNet de base
CONTROLNET_DIR="/workspace/models/ControlNet"
mkdir -p "$CONTROLNET_DIR"

# Canny ControlNet
CANNY_MODEL="$CONTROLNET_DIR/control_v11p_sd15_canny.pth"
CANNY_URL="https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.pth"
download_if_not_exists "$CANNY_URL" "$CANNY_MODEL"

# Pose ControlNet
POSE_MODEL="$CONTROLNET_DIR/control_v11p_sd15_openpose.pth"
POSE_URL="https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.pth"
download_if_not_exists "$POSE_URL" "$POSE_MODEL"

# Depth ControlNet
DEPTH_MODEL="$CONTROLNET_DIR/control_v11f1p_sd15_depth.pth"
DEPTH_URL="https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.pth"
download_if_not_exists "$DEPTH_URL" "$DEPTH_MODEL"

# AnimateDiff motion module
ANIMATEDIFF_DIR="/workspace/models/AnimateDiff"
mkdir -p "$ANIMATEDIFF_DIR"
MM_MODEL="$ANIMATEDIFF_DIR/mm_sd_v15_v2.ckpt"
MM_URL="https://huggingface.co/guoyww/animatediff/resolve/main/mm_sd_v15_v2.ckpt"
download_if_not_exists "$MM_URL" "$MM_MODEL"

echo "🔄 Configuration de l'environnement..."

# Lancer l'application web
cd /workspace/stable-diffusion-webui

# Configuration pour RunPod
export PYTHONPATH="/workspace/stable-diffusion-webui:$PYTHONPATH"
export COMMANDLINE_ARGS="--listen --port 7860 --enable-insecure-extension-access --xformers --api --cors-allow-origins=* --no-half-vae"

# Si un fichier app.py est présent à la racine, l'utiliser
if [ -f "/workspace/app.py" ]; then
    echo "🌐 Lancement de l'API personnalisée..."
    cd /workspace
    python app.py
else
    echo "🌐 Lancement de la WebUI AUTOMATIC1111..."
    cd /workspace/stable-diffusion-webui
    python launch.py $COMMANDLINE_ARGS
fi
