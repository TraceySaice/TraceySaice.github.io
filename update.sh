#!/bin/bash

# MCSManager 脚本更新和执行
# 当前脚本版本号
CURRENT_VERSION="0.0.1"
SCRIPT_NAME=$(basename "$0")

# GitHub 仓库中脚本的 URL
SCRIPT_URL=""

# 临时文件用于下载新的脚本
TEMP_SCRIPT="/tmp/${SCRIPT_NAME}"

# 获取 GitHub 上脚本的版本号
GITHUB_VERSION=$(wget -qO- "$SCRIPT_URL" | grep '# CURRENT_VERSION=' | cut -d '"' -f 2)

# 比较版本号
if [[ "$GITHUB_VERSION" != "$CURRENT_VERSION" && "$GITHUB_VERSION" > "$CURRENT_VERSION" ]]; then
  # 下载最新的脚本
  wget -qO "$TEMP_SCRIPT" "$SCRIPT_URL" || {
    echo "错误: 无法下载最新的脚本。"
    exit 1
  }

  # 给新脚本执行权限
  chmod +x "$TEMP_SCRIPT"

  # 执行新脚本
  "./$TEMP_SCRIPT"

  # 删除旧脚本
  rm -- "$0"
else
  # 执行当前脚本
  main
fi

# 主函数
main() {
  # MCSManager 的 GitHub 仓库 URL
  REPO_URL="https://github.com/MCSManager/MCSManager"

  # 下载目录，可自行修改
  DOWNLOAD_DIR="/tmp"

  # 安装目录，可自行修改
  INSTALL_DIR="/tmp/1"

  # 创建下载目录
  mkdir -p "$DOWNLOAD_DIR"

  # 进入下载目录
  cd "$DOWNLOAD_DIR"

  # 获取最新的 MCSManager 版本下载地址
  LATEST_URL=$(curl -sL "$REPO_URL/releases/latest" | grep -o -E "https://github.com/MCSManager/MCSManager/releases/download/[^/]+/mcsmanager_linux_release.tar.gz")

  # 下载最新的 MCSManager 版本
  wget -c "$LATEST_URL" -O "mcsmanager_linux_release.tar.gz"

  # 如果下载成功，则解压到安装目录
  if [ $? -eq 0 ]; then
    # 创建安装目录
    mkdir -p "$INSTALL_DIR"

    # 解压到安装目录
    tar -xzf "mcsmanager_linux_release.tar.gz" -C "$INSTALL_DIR"
    cd $INSTALL_DIR
    
    ./install-dependency.sh

    # 输出成功信息
    echo "MCSManager 已成功安装到 $INSTALL_DIR"
  else
    # 输出错误信息
    echo "下载 MCSManager 失败，请检查网络连接或 GitHub 仓库状态。"
  fi
}

# 默认执行主函数
main