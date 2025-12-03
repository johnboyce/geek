# AI and Machine Learning Setup

## Overview

The Geekom AX8 features AMD Ryzen AI (XDNA NPU) with up to 16 TOPS of AI performance, making it capable of running AI workloads locally. This guide covers setting up AI/ML development environments and leveraging the NPU for accelerated inference.

## AMD Ryzen AI (NPU) Overview

### What is Ryzen AI?

The AMD Ryzen 9 8945HS includes a dedicated Neural Processing Unit (NPU) based on AMD XDNA architecture:

- **16 TOPS Performance**: Efficient AI inference acceleration
- **Low Power**: Offloads AI tasks from CPU/GPU for better battery life (laptops) and thermal management
- **Privacy-First**: Run AI models locally without cloud dependencies
- **Wide Compatibility**: Supports ONNX, DirectML, OpenVINO, and other frameworks

### Linux Support

While AMD Ryzen AI has excellent Windows support, Linux support is evolving:

- **ROCm**: AMD's open-source platform for GPU computing (limited NPU support currently)
- **ONNX Runtime**: Cross-platform AI inference with AMD support
- **OpenVINO**: Intel's toolkit with some AMD compatibility
- **CPU/GPU Fallback**: Most frameworks can use CPU or Radeon 780M GPU if NPU drivers aren't available

## Python Machine Learning Environment

### Install Python and Essential Tools

```bash
# Install Python 3.11+ and pip
sudo apt update
sudo apt install -y python3.11 python3.11-venv python3-pip python3-dev

# Install build tools for native extensions
sudo apt install -y build-essential libssl-dev libffi-dev python3.11-dev

# Set Python 3.11 as default (optional)
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
```

### Create Virtual Environment

```bash
# Create a dedicated ML environment
python3 -m venv ~/ml-env

# Activate the environment
source ~/ml-env/bin/activate

# Upgrade pip
pip install --upgrade pip setuptools wheel
```

### Install Core ML Libraries

```bash
# Essential ML libraries
pip install numpy pandas scipy scikit-learn matplotlib seaborn

# Deep Learning frameworks
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Alternative: TensorFlow
pip install tensorflow

# ONNX Runtime (for AMD NPU support)
pip install onnxruntime

# Jupyter for interactive development
pip install jupyter jupyterlab ipython
```

### Install AMD ROCm (Optional - GPU Acceleration)

ROCm enables GPU acceleration for AI workloads on the Radeon 780M:

```bash
# Add ROCm repository
wget -qO - https://repo.radeon.com/rocm/rocm.gpg.key | sudo apt-key add -
echo 'deb [arch=amd64] https://repo.radeon.com/rocm/apt/6.0 ubuntu main' | \
  sudo tee /etc/apt/sources.list.d/rocm.list

# Update and install ROCm
sudo apt update
sudo apt install -y rocm-hip-sdk rocm-opencl-sdk

# Add user to render and video groups
sudo usermod -a -G render,video $USER

# Reboot to apply changes
sudo reboot
```

After reboot, verify ROCm installation:

```bash
# Check ROCm info
rocm-smi

# Verify GPU detection
rocminfo | grep "Name:"
```

### Install PyTorch with ROCm Support

```bash
# Activate your ML environment
source ~/ml-env/bin/activate

# Install PyTorch with ROCm support
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.0
```

Verify GPU acceleration:

```python
import torch
print(f"PyTorch version: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")
if torch.cuda.is_available():
    print(f"GPU: {torch.cuda.get_device_name(0)}")
```

## ONNX Runtime with NPU Support

ONNX Runtime provides the best path for AMD Ryzen AI NPU acceleration on Linux:

### Install ONNX Runtime

```bash
source ~/ml-env/bin/activate

# Install ONNX Runtime
pip install onnxruntime

# For GPU support (Radeon 780M)
pip install onnxruntime-gpu

# Additional ONNX tools
pip install onnx onnxmltools skl2onnx
```

### Convert Models to ONNX Format

```python
import torch
import torch.onnx

# Example: Convert a PyTorch model to ONNX
model = YourModel()
model.eval()

dummy_input = torch.randn(1, 3, 224, 224)
torch.onnx.export(
    model,
    dummy_input,
    "model.onnx",
    export_params=True,
    opset_version=14,
    input_names=['input'],
    output_names=['output']
)
```

### Run Inference with ONNX Runtime

```python
import onnxruntime as ort
import numpy as np

# Create inference session
session = ort.InferenceSession("model.onnx")

# Prepare input
input_name = session.get_inputs()[0].name
input_data = np.random.randn(1, 3, 224, 224).astype(np.float32)

# Run inference
outputs = session.run(None, {input_name: input_data})
print(outputs)
```

## Popular AI/ML Tools and Frameworks

### Hugging Face Transformers

For working with pre-trained language models:

```bash
source ~/ml-env/bin/activate
pip install transformers datasets accelerate
```

Example usage:

```python
from transformers import pipeline

# Sentiment analysis
classifier = pipeline("sentiment-analysis")
result = classifier("I love using the Geekom AX8 for AI development!")
print(result)

# Text generation (smaller models work better)
generator = pipeline("text-generation", model="distilgpt2")
text = generator("The future of AI is", max_length=50, num_return_sequences=1)
print(text)
```

### Stable Diffusion Web UI

Run Stable Diffusion locally for AI image generation:

```bash
# Install dependencies
sudo apt install -y wget git python3 python3-venv libgl1 libglib2.0-0

# Clone repository
cd ~/
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
cd stable-diffusion-webui

# Run the web UI (first run downloads models)
./webui.sh --listen --port 7860
```

Access at `http://localhost:7860`

**Note**: Image generation will use the Radeon 780M GPU. Performance will be moderate compared to dedicated GPUs.

### LM Studio

Run large language models locally:

```bash
# Download LM Studio AppImage
wget https://releases.lmstudio.ai/linux/x86/0.2.9/LM-Studio-0.2.9.AppImage
chmod +x LM-Studio-0.2.9.AppImage

# Run LM Studio
./LM-Studio-0.2.9.AppImage
```

Recommended models for AX8:
- **Llama 2 7B**: Good balance of performance and quality
- **Mistral 7B**: Excellent performance for size
- **Phi-2 (2.7B)**: Fast inference, good for coding tasks
- **TinyLlama (1.1B)**: Very fast, good for testing

### Ollama

Command-line tool for running LLMs:

```bash
# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Run a model
ollama run llama2

# List available models
ollama list

# Pull a specific model
ollama pull mistral
```

### Jupyter Lab for Interactive Development

```bash
source ~/ml-env/bin/activate
jupyter lab --port=8888
```

## AI Development IDEs

### VS Code with AI Extensions

```bash
# Install VS Code (if not already installed)
sudo snap install code --classic

# Install Python extension
code --install-extension ms-python.python

# Install Jupyter extension
code --install-extension ms-toolsai.jupyter

# Install AI/ML extensions
code --install-extension ms-toolsai.vscode-ai
code --install-extension GitHub.copilot
```

### PyCharm Professional

```bash
# Download via JetBrains Toolbox (see Development Setup guide)
# Or download directly
wget https://download.jetbrains.com/python/pycharm-professional-2024.1.tar.gz
tar -xzf pycharm-professional-2024.1.tar.gz
cd pycharm-*/bin
./pycharm.sh
```

## AI Model Optimization

### Quantization for Better Performance

Quantization reduces model size and improves inference speed:

```python
import torch

# Example: Quantize a PyTorch model
model = YourModel()
model.eval()

# Dynamic quantization (easiest)
quantized_model = torch.quantization.quantize_dynamic(
    model,
    {torch.nn.Linear},
    dtype=torch.qint8
)

# Test inference speed
import time
start = time.time()
output = quantized_model(input_data)
print(f"Inference time: {time.time() - start:.3f}s")
```

### Model Pruning

Remove unnecessary weights to speed up models:

```bash
pip install torch-pruning
```

### ONNX Model Optimization

```bash
pip install onnxruntime-tools

# Optimize ONNX model
python -m onnxruntime.transformers.optimizer \
  --input model.onnx \
  --output model_optimized.onnx \
  --optimization_level 2
```

## Computer Vision with OpenCV

```bash
source ~/ml-env/bin/activate
pip install opencv-python opencv-contrib-python
```

Example: Real-time object detection:

```python
import cv2

# Load pre-trained model
net = cv2.dnn.readNetFromCaffe('deploy.prototxt', 'model.caffemodel')

# Capture video
cap = cv2.VideoCapture(0)

while True:
    ret, frame = cap.read()
    if not ret:
        break
    
    # Perform detection
    blob = cv2.dnn.blobFromImage(frame, 0.007843, (300, 300), 127.5)
    net.setInput(blob)
    detections = net.forward()
    
    # Display results
    cv2.imshow('Detection', frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
```

## Performance Monitoring

### Monitor AI Workload Performance

```bash
# Install monitoring tools
sudo apt install -y nvtop htop

# Monitor GPU usage
nvtop

# Monitor CPU/RAM
htop

# Check ROCm GPU stats
rocm-smi
```

### Benchmark AI Performance

```bash
source ~/ml-env/bin/activate
pip install pytest-benchmark
```

Example benchmark:

```python
import torch
import time

def benchmark_inference(model, input_data, iterations=100):
    model.eval()
    with torch.no_grad():
        # Warmup
        for _ in range(10):
            _ = model(input_data)
        
        # Benchmark
        start = time.time()
        for _ in range(iterations):
            _ = model(input_data)
        end = time.time()
        
    avg_time = (end - start) / iterations
    print(f"Average inference time: {avg_time*1000:.2f}ms")
    print(f"Throughput: {1/avg_time:.2f} inferences/sec")
```

## AI Ethics and Best Practices

### Data Privacy

- **Local Processing**: Leverage NPU for private, on-device AI
- **Data Minimization**: Only collect necessary data
- **Secure Storage**: Encrypt sensitive training data

### Model Testing

- **Validate Accuracy**: Test models on diverse datasets
- **Bias Detection**: Check for unfair biases in model outputs
- **Edge Cases**: Test unusual inputs

### Resource Management

- **Memory Limits**: Monitor RAM usage for large models
- **Thermal Management**: Ensure adequate cooling during training
- **Power Consumption**: Balance performance vs. efficiency

## Troubleshooting

### NPU Not Detected

```bash
# Check system info
lspci | grep -i vga
lspci | grep -i amd

# Check kernel modules
lsmod | grep amd

# Update kernel and firmware
sudo apt update
sudo apt upgrade
sudo apt install linux-firmware
```

### ROCm Installation Issues

```bash
# Remove existing ROCm
sudo apt remove rocm-*
sudo apt autoremove

# Reinstall
sudo apt update
sudo apt install rocm-hip-sdk

# Verify installation
/opt/rocm/bin/rocminfo
```

### Out of Memory Errors

- Use smaller models or batch sizes
- Enable gradient checkpointing for training
- Use mixed precision training (FP16)
- Increase system swap space

### Slow Inference Performance

- Ensure ROCm drivers are installed
- Use quantized models (INT8/INT4)
- Enable ONNX Runtime optimizations
- Close unnecessary background applications

## Additional Resources

### Documentation
- [AMD ROCm Documentation](https://rocm.docs.amd.com/)
- [ONNX Runtime Documentation](https://onnxruntime.ai/docs/)
- [PyTorch Documentation](https://pytorch.org/docs/)
- [TensorFlow Documentation](https://www.tensorflow.org/)

### Communities
- [AMD ROCm GitHub](https://github.com/RadeonOpenCompute/ROCm)
- [r/LocalLLaMA](https://reddit.com/r/LocalLLaMA) - Local AI models
- [r/StableDiffusion](https://reddit.com/r/StableDiffusion) - Image generation
- [Hugging Face Forums](https://discuss.huggingface.co/)

### Model Resources
- [Hugging Face Model Hub](https://huggingface.co/models)
- [ONNX Model Zoo](https://github.com/onnx/models)
- [PyTorch Hub](https://pytorch.org/hub/)

## Next Steps

After setting up your AI/ML environment:

1. **Explore Pre-trained Models**: Start with Hugging Face transformers
2. **Run Local LLMs**: Try Ollama or LM Studio with smaller models
3. **Image Generation**: Experiment with Stable Diffusion
4. **Build Custom Models**: Use PyTorch or TensorFlow for your projects
5. **Optimize Performance**: Quantize and prune models for better speed
6. **Join Communities**: Share your work and learn from others

The Geekom AX8's combination of powerful CPU, integrated GPU, and AI NPU makes it an excellent platform for AI/ML development and local inference!
