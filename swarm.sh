#!/bin/bash

echo -e "\033[0;32m>>> 正在部署 RL Swarm 节点（macOS + CPU 模式）\033[0m"

# 检查 Homebrew
if ! command -v brew &> /dev/null; then
    echo -e "\033[0;31m未检测到 Homebrew，正在安装...\033[0m"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 安装 Python3 和 Git（如果未安装）
brew install python@3.11 git

# 安装 virtualenv
pip3 install virtualenv

# 克隆 RL Swarm 仓库
if [ ! -d "rl-swarm" ]; then
    git clone https://github.com/gensyn-ai/rl-swarm.git
else
    echo "已有 rl-swarm 文件夹，跳过克隆"
fi

cd rl-swarm

# 创建并激活虚拟环境
python3 -m venv venv
source venv/bin/activate

# 安装依赖
pip install --upgrade pip
pip install -r requirements.txt

# 检测 CPU 核心数
CPU_CORES=$(sysctl -n hw.ncpu)
DEFAULT_THREADS=$((CPU_CORES / 2))
echo ""
echo -e "\033[0;36m检测到你有 $CPU_CORES 个 CPU 核心。\033[0m"
read -p "请输入你想分配给 RL Swarm 的线程数（建议：$DEFAULT_THREADS）: " USER_THREADS

# 如果用户没输入，就用默认值
if [ -z "$USER_THREADS" ]; then
    USER_THREADS=$DEFAULT_THREADS
fi

export OMP_NUM_THREADS=$USER_THREADS
echo -e "\033[0;33m已设置 OMP_NUM_THREADS=$OMP_NUM_THREADS\033[0m"

# 启动 RL Swarm 节点
if [ -f "./run_rl_swarm.sh" ]; then
    chmod +x run_rl_swarm.sh
    ./run_rl_swarm.sh
else
    echo "未找到 run_rl_swarm.sh，尝试使用 main.py 启动"
    python main.py
fi
