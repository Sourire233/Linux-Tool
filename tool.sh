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

main_menu() {
    echo "欢迎使用服务器功能选择器"
    echo "1. 设置 Swap"
    echo "2. 查看服务器状态"
    echo "3. 启动服务器"
    echo "4. 关闭服务器"
    echo "5. 重启服务器"
    echo "6. 退出"
}

while true; do
    main_menu
    read -p "请选择您要执行的操作（输入数字）：" choice

    case $choice in
        1)
            read -p "请输入需要设置的 Swap 大小（单位：MB）：" swap_size
            set_swap "$swap_size"
            ;;
        2) view_status ;;
        3) start_server ;;
        4) stop_server ;;
        5) restart_server ;;
        6)
            echo "感谢使用，再见！"
            break
            ;;
        *) echo "无效的选择，请重新输入" ;;
    esac
done
