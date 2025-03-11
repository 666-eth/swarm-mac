#!/bin/bash

# 检查并安装 Homebrew（如果未安装）
if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # 添加 Homebrew 到 PATH
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 检查并安装 git
if ! command -v git >/dev/null 2>&1; then
    echo "Git not found. Installing git..."
    brew install git
fi

# 检查并安装 python3
if ! command -v python3 >/dev/null 2>&1; then
    echo "Python3 not found. Installing python3..."
    brew install python
fi

echo "Starting setup process..."

# 1. 克隆 GitHub 仓库
echo "Cloning repository..."
git clone https://github.com/gensyn-ai/rl-swarm.git

# 进入项目目录
cd rl-swarm || exit

# 2. 创建虚拟环境
echo "Creating virtual environment..."
python3 -m venv .venv

# 3. 激活虚拟环境
echo "Activating virtual environment..."
source .venv/bin/activate

# 检查 run_rl_swarm.sh 是否存在并可执行
if [ ! -f "run_rl_swarm.sh" ]; then
    echo "Error: run_rl_swarm.sh not found in repository"
    exit 1
fi

if [ ! -x "run_rl_swarm.sh" ]; then
    echo "Making run_rl_swarm.sh executable..."
    chmod +x run_rl_swarm.sh
fi

# 4. 运行 run_rl_swarm.sh 脚本
echo "Running rl-swarm..."
./run_rl_swarm.sh

echo "Setup and execution completed!"
