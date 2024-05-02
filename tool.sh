#!/bin/bash

check_installation() {
    # 检查是否安装了 fallocate、mkswap 和 swapon 命令
    if ! command -v fallocate >/dev/null 2>&1 || ! command -v mkswap >/dev/null 2>&1 || ! command -v swapon >/dev/null 2>&1; then
        echo "Error: This script requires fallocate, mkswap, and swapon commands to run."
        echo "Please install these commands and try again."
        exit 1
    fi
}

set_swap() {
    swap_size="$1"
    swap_file="/swapfile"
    # 创建一个指定大小的 swap 文件
    fallocate -l "${swap_size}M" "$swap_file"
    # 将文件设置为 swap 文件
    mkswap "$swap_file"
    # 启用 swap 文件
    swapon "$swap_file"
    echo "Swap 已成功设置为 ${swap_size}MB"
}

view_status() {
    free -h
}

start_server() {
    echo "服务器已启动"
}

stop_server() {
    echo "服务器已关闭"
}

restart_server() {
    echo "服务器已重启"
}

check_installation

# 检查参数数量
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <operation>"
    echo "Available operations: set_swap, view_status, start_server, stop_server, restart_server"
    exit 1
fi

# 根据参数执行相应操作
case $1 in
    "set_swap") 
        read -p "请输入需要设置的 Swap 大小（单位：MB）：" swap_size
        set_swap "$swap_size"
        ;;
    "view_status") view_status ;;
    "start_server") start_server ;;
    "stop_server") stop_server ;;
    "restart_server") restart_server ;;
    *)
        echo "Error: Invalid operation."
        echo "Available operations: set_swap, view_status, start_server, stop_server, restart_server"
        exit 1
        ;;
esac
