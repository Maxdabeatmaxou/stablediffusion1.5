# BACKEND ULTIME STABLE DIFFUSION 1.5 PROD

Ce package contient tout le nécessaire pour déployer Stable Diffusion 1.5 sur RunPod ou tout autre environnement compatible Docker avec accès GPU.

## 📦 Contenu du package

- Dockerfile - Configuration Docker optimisée pour CUDA 11.8  
- startup.sh - Script de démarrage automatique, téléchargement des modèles  
- app.py - API Flask personnalisée et interface simplifiée  
- webui.py - Configuration optimisée pour AUTOMATIC1111 WebUI  
- Documentation complète (ce README)

## 🚀 Installation rapide sur RunPod

1. Créez un nouveau pod sur RunPod avec une image Docker CUDA compatible  
2. Téléchargez ce package sur votre pod  
3. Construisez et exécutez le container:
```bash
cd /chemin/vers/package
docker build -t sd15-runpod .
docker run -d --gpus all -p 7860:7860 -v /chemin/local/models:/workspace/models sd15-runpod
```

## ⚙️ Fonctionnalités

- AUTOMATIC1111 WebUI complet  
- API REST compatible avec les standards  
- ControlNet avec modèles canny, pose, depth  
- Adetailer pour l'amélioration des visages et mains  
- AnimateDiff pour générer des animations  
- CivitAI Helper pour télécharger facilement des modèles  
- LoRA Manager pour gérer vos LoRAs  
- Gestion optimisée de la mémoire VRAM  
- Support des formats de modèles `.safetensors`

## 🔧 Configuration personnalisée

**Variables d'environnement**
- `SD_MODEL`: Chemin vers un modèle SD personnalisé  
- `SD_VAE`: Chemin vers un VAE personnalisé  
- `SD_EXTRA_ARGS`: Arguments supplémentaires pour WebUI

**Dossiers de données**
- `/workspace/models` - Stockage des modèles  
  - `/workspace/models/Stable-diffusion` - Modèles principaux  
  - `/workspace/models/VAE` - Modèles VAE  
  - `/workspace/models/Lora` - Adaptateurs LoRA  
  - `/workspace/models/ControlNet` - Modèles ControlNet  
- `/workspace/outputs` - Images générées  
- `/workspace/extensions` - Extensions additionnelles

## 🔌 Utilisation de l'API

L'API est accessible via `http://[votre-ip]:7860/` avec les points d'accès suivants:

- `/txt2img` - Génération d'images à partir de texte  
- `/img2img` - Modification d'images existantes  
- `/models` - Liste des modèles disponibles  
- `/status` - État du serveur  
- `/sdapi/v1/...` - API standard AUTOMATIC1111

### Exemple de requête `txt2img`

```json
{
  "prompt": "a beautiful landscape, mountains, lake, sunset, detailed, 4k",
  "negative_prompt": "blurry, bad quality",
  "steps": 30,
  "width": 768,
  "height": 512,
  "cfg_scale": 7.5,
  "sampler_name": "DPM++ 2M Karras"
}
```

## 📝 Modules inclus

| Composant              | Statut | Notes                          |
|------------------------|--------|--------------------------------|
| Stable Diffusion 1.5   | ✅     | Format `.safetensors`         |
| AUTOMATIC1111 WebUI    | ✅     | Interface graphique + API     |
| ControlNet             | ✅     | Modèles canny, pose, depth    |
| Adetailer              | ✅     | Amélioration des visages/mains|
| CivitAI Helper         | ✅     | Téléchargement de modèles     |
| Image Browser          | ✅     | Galerie + historique          |
| OpenPose Editor        | ✅     | Contrôle manuel de pose       |
| LoRA Manager           | ✅     | Chargement dynamique          |
| AnimateDiff            | ✅     | Animation vidéo               |

## 🔗 Liens utiles

- [AUTOMATIC1111 WebUI](https://github.com/AUTOMATIC1111/stable-diffusion-webui)  
- [ControlNet](https://github.com/lllyasviel/ControlNet)  
- [AnimateDiff](https://github.com/continue-revolution/sd-webui-animatediff)  
- [Adetailer](https://github.com/Bing-su/adetailer)  
- [RunPod Documentation](https://www.runpod.io/)

## ⚠️ Résolution des problèmes

**Problèmes de mémoire GPU**
- Ajoutez `--medvram` ou `--lowvram` aux arguments de démarrage  
- Réduisez la taille des images générées  
- Utilisez moins de modèles ControlNet simultanément

**Modèles manquants**
- Vérifiez la connexion internet  
- Téléchargez manuellement dans `/workspace/models/`

## 📜 Licence

Ce package est fourni sous licence MIT. Voir le fichier LICENSE pour plus de détails.
