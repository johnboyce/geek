# Development Environment Setup

## Essential Development Tools

### Version Control
```bash
# Git (usually pre-installed)
sudo apt install -y git git-lfs

# Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global init.defaultBranch main

# Generate SSH key for GitHub/GitLab
ssh-keygen -t ed25519 -C "your.email@example.com"
cat ~/.ssh/id_ed25519.pub
# Add this key to your GitHub/GitLab account
```

### Build Tools
```bash
# Essential build tools
sudo apt install -y build-essential cmake ninja-build

# Additional development libraries
sudo apt install -y libssl-dev libreadline-dev zlib1g-dev
```

## Programming Languages & Runtimes

### Node.js & npm
```bash
# Using NodeSource repository for latest version
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Verify installation
node --version
npm --version

# Install useful global packages
npm install -g yarn pnpm typescript ts-node nodemon
```

### Python
```bash
# Python 3 (usually pre-installed)
sudo apt install -y python3 python3-pip python3-venv

# Install pipx for global tools
sudo apt install -y pipx
pipx ensurepath

# Install useful Python tools
pipx install poetry
pipx install black
pipx install pylint
pipx install ipython
```

### Go
```bash
# Download and install Go
wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
rm go1.21.5.linux-amd64.tar.gz

# Add to PATH (add to ~/.bashrc or ~/.zshrc)
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc

go version
```

### Rust
```bash
# Install Rust via rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

rustc --version
cargo --version
```

### Java
```bash
# OpenJDK 17 (LTS)
sudo apt install -y openjdk-17-jdk openjdk-17-jre

# Verify installation
java --version
javac --version

# Optional: Install Maven and Gradle
sudo apt install -y maven gradle
```

### Docker & Containers

#### Docker
```bash
# Install Docker Engine
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Verify installation
docker --version
docker compose version
```

#### Podman (Alternative to Docker)
```bash
sudo apt install -y podman podman-compose
podman --version
```

### Database Systems

#### PostgreSQL
```bash
sudo apt install -y postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Create database and user
sudo -u postgres psql
# In psql:
# CREATE USER dev WITH PASSWORD 'devpassword';
# CREATE DATABASE devdb OWNER dev;
# \q
```

#### MySQL/MariaDB
```bash
sudo apt install -y mariadb-server mariadb-client
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mysql_secure_installation
```

#### Redis
```bash
sudo apt install -y redis-server
sudo systemctl start redis-server
sudo systemctl enable redis-server
```

#### MongoDB
```bash
# Import MongoDB GPG key
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-archive-keyring.gpg

# Add repository
echo "deb [signed-by=/usr/share/keyrings/mongodb-archive-keyring.gpg] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

sudo apt update
sudo apt install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
```

## IDEs and Editors

### Visual Studio Code
```bash
# Download and install VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg

sudo apt update
sudo apt install -y code

# Install useful extensions (run as user)
code --install-extension ms-python.python
code --install-extension golang.go
code --install-extension rust-lang.rust-analyzer
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
```

### JetBrains Toolbox
```bash
# Download from https://www.jetbrains.com/toolbox-app/
# Install and manage IntelliJ IDEA, PyCharm, etc.
wget -O jetbrains-toolbox.tar.gz "https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.1.3.18901.tar.gz"
tar -xzf jetbrains-toolbox.tar.gz
cd jetbrains-toolbox-*
./jetbrains-toolbox
```

### Vim/Neovim
```bash
# Neovim (modern Vim)
sudo apt install -y neovim

# Set as default editor
echo 'export EDITOR=nvim' >> ~/.bashrc
source ~/.bashrc
```

## Shell Enhancement

### Zsh with Oh My Zsh
```bash
# Install Zsh
sudo apt install -y zsh

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install useful plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Edit ~/.zshrc and add to plugins:
# plugins=(git zsh-autosuggestions zsh-syntax-highlighting docker docker-compose npm node)
```

## Development Utilities

### tmux (Terminal Multiplexer)
```bash
sudo apt install -y tmux

# Create basic config
cat > ~/.tmux.conf << 'EOF'
# Enable mouse support
set -g mouse on

# Increase history
set -g history-limit 10000

# Start windows at 1
set -g base-index 1

# Better prefix key
unbind C-b
set -g prefix C-a
bind C-a send-prefix
EOF
```

### HTTPie (Better curl)
```bash
pipx install httpie
```

### jq (JSON processor)
```bash
sudo apt install -y jq
```

### Postman
```bash
# Install via snap
sudo snap install postman
```

## Performance Tuning

### Enable BBR TCP Congestion Control
```bash
echo 'net.core.default_qdisc=fq' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_congestion_control=bbr' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### Optimize for SSD
```bash
# Check if TRIM is enabled
sudo systemctl status fstrim.timer

# Enable if not active
sudo systemctl enable fstrim.timer
```

### Increase File Watchers (for development)
```bash
echo 'fs.inotify.max_user_watches=524288' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

## Backup Strategy

### Timeshift for System Snapshots
```bash
sudo apt install -y timeshift
# Configure via GUI: timeshift-gtk
```

### Restic for User Data
```bash
sudo apt install -y restic
```
