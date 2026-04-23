#!/bin/bash

# --- 1. 定义路径 ---
# macOS/Linux 习惯将本地二进制文件放在 ~/.local/bin
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

# --- 2. 检查并安装 Git ---
# macOS 通常自带 Git，如果没有，建议通过 Homebrew 安装
if ! command -v git &> /dev/null; then
    echo "Git 未找到。正在尝试安装..."
    
    # 检查是否安装了 Homebrew
    if command -v brew &> /dev/null; then
        brew install git
    else
        echo "请先安装 Homebrew (https://brew.sh/) 或 Xcode Command Line Tools。"
        echo "你可以运行: xcode-select --install"
        exit 1
    fi
else
    echo "Git 已安装: $(git --version)"
fi

# --- 3. 更新环境变量 ---
# 识别当前的 Shell 配置文件 (.zshrc 或 .bash_profile)
SHELL_CONFIG="$HOME/.zshrc"
[[ "$SHELL" == */bash* ]] && SHELL_CONFIG="$HOME/.bash_profile"

# 将路径添加到配置文件（如果尚未添加）
if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
    echo "正在将 $LOCAL_BIN 添加到 $SHELL_CONFIG..."
    echo "export PATH=\"$LOCAL_BIN:\$PATH\"" >> "$SHELL_CONFIG"
    
    # 立即对当前会话生效
    export PATH="$LOCAL_BIN:$PATH"
    echo "用户 PATH 已更新。"
fi

# --- 4. 安装 Claude Code ---
echo "正在安装 Claude Code..."
# 根据 Claude 官方 macOS 安装指令（通常使用 curl）
curl -s https://claude.ai/install.sh | sh

# --- 5. 验证安装 ---
echo -e "\n验证结果:"
git --version
if command -v claude &> /dev/null; then
    claude --version
else
    echo "Claude 命令暂未在当前窗口生效，请运行 'source $SHELL_CONFIG' 或重启终端。"
fi