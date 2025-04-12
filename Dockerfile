FROM python:3.12

# Clone the repository
RUN git clone https://github.com/comfyanonymous/ComfyUI.git

# Set the working directory
WORKDIR /ComfyUI

RUN apt-get update && apt-get install -y \
    git \
    libgl1-mesa-glx \
    libglib2.0-0 \
    ffmpeg \
    wget

# Update pip, install GPU dependencies, and install Comfy dependencies
RUN pip install --upgrade pip && pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121 && pip install -r requirements.txt
RUN pip install --no-cache-dir --upgrade pip setuptools wheel
RUN pip install --no-cache-dir \
    opencv-python-headless==4.8.1.78 \
    triton>=2.3.0 \
    sageattention==1.0.6 \
    comfy-cli

# Clone ComfyUI-Manager
RUN comfy --skip-prompt --workspace /comfy/ComfyUI install --nvidia
COPY WAN-2.1-720p-Image-to-Video-Teacache-Sage-Attention.json /comfy/ComfyUI/WAN-2.1-720p-Image-to-Video-Teacache-Sage-Attention.json
RUN comfy node install-deps --workflow=/comfy/ComfyUI/WAN-2.1-720p-Image-to-Video-Teacache-Sage-Attention.json

# Set the entry point for the container
CMD comfy launch -- --listen 0.0.0.0 --port ${PORT:-8188}
