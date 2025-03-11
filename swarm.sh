#!/bin/bash

# 检查是否已安装Docker
if ! command -v docker &> /dev/null; then
    echo "Docker 未安装，正在安装..."
    
    # 安装 Homebrew（如果未安装）
    if ! command -v brew &> /dev/null; then
        echo "安装 Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    # 通过 Homebrew 安装 Docker
    brew install --cask docker
    
    # 启动 Docker
    open /Applications/Docker.app
    
    # 等待 Docker 启动
    echo "等待 Docker 启动..."
    sleep 10
    until docker ps >/dev/null 2>&1; do
        sleep 2
    done
    echo "Docker 已启动"
else
    echo "Docker 已安装"
fi

# 运行指定的 Docker 容器
echo "正在拉取并运行容器..."
docker run --pull=always -it --rm \
    europe-docker.pkg.dev/gensyn-public-b7d9/public/rl-swarm:v0.0.1 \
    ./run_hivemind_docker.sh
