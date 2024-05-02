#!/bin/bash

# 设置别名
alias tool='wget -O tool.sh https://raw.githubusercontent.com/Sourire233/Linux-Tool/main/tool.sh && chmod +x tool.sh && ./tool.sh'

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
    # 关闭已存在的 Swap
    swapoff "$swap_file" 2>/dev/null
    # 删除已存在的 Swap 文件
    rm "$swap_file" 2>/dev/null
    # 创建一个指定大小的 Swap 文件
    fallocate -l "${swap_size}M" "$swap_file"
    # 将文件设置为 Swap 文件
    mkswap "$swap_file"
    # 启用 Swap 文件
    swapon "$swap_file"
    echo "Swap 已成功设置为 ${swap_size}MB"
}

close_swap() {
    swap_file="/swapfile"
    swapoff "$swap_file" 2>/dev/null
    rm "$swap_file" 2>/dev/null
    echo "Swap 已成功关闭"
}

uninstall() {
    rm "$0"
    echo "脚本已卸载"
    exit 0
}

manage_bbr() {
    echo "正在下载BBR管理脚本..."
    wget -O bbr.sh https://raw.githubusercontent.com/Sourire233/Linux-Tool/main/home/bbr.sh
    chmod +x bbr.sh
    echo "执行BBR管理脚本..."
    ./bbr.sh
    rm bbr.sh
}

main_menu() {
    echo "欢迎使用服务器功能选择器"
    echo "1. 设置 Swap"
    echo "2. 关闭 Swap"
    echo "3. BBR 管理"
    echo "4. 卸载脚本"
    echo "5. 退出"
}

check_installation

while true; do
    main_menu
    read -p "请选择您要执行的操作（输入数字）：" choice

    case $choice in
        1)
            read -p "请输入需要设置的 Swap 大小（单位：MB）：" swap_size
            set_swap "$swap_size"
            ;;
        2)
            close_swap
            ;;
        3)
            manage_bbr
            ;;
        4)
            uninstall
            ;;
        5)
            echo "感谢使用，再见！"
            break
            ;;
        *)
            echo "无效的选择，请重新输入"
            ;;
    esac
done
