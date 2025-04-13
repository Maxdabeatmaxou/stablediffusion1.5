#!/bin/bash
cd /workspace
python3 launch.py --xformers --medvram --listen --port 7860 --enable-insecure-extension-access
