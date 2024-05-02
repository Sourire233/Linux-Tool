#!/bin/bash

# 检查是否为root用户
if [ "$(id -u)" -ne "0" ]; then
    echo "请使用 root 用户运行此脚本"
    exit 1
fi

# 检查是否已经安装了 wget 或 curl
if ! command -v wget >/dev/null 2>&1 && ! command -v curl >/dev/null 2>&1; then
    echo "错误：此脚本需要 wget 或 curl 以下载必要的文件。"
    exit 1
fi

# 检查系统是否为 Ubuntu 16.04、18.04、20.04、Debian 9、10、11 或 12
if [ ! -e "/etc/os-release" ]; then
    echo "错误：不支持的操作系统"
    exit 1
fi
. /etc/os-release
os="${ID}-${VERSION_ID%%.*}"
if [ "$os" != "ubuntu-16.04" ] && [ "$os" != "ubuntu-18.04" ] && [ "$os" != "ubuntu-20.04" ] && [ "$os" != "debian-9" ] && [ "$os" != "debian-10" ] && [ "$os" != "debian-11" ] && [ "$os" != "debian-12" ]; then
    echo "错误：此脚本仅支持 Ubuntu 16.04、18.04、20.04、Debian 9、10、11 和 12"
    exit 1
fi

function check_bbr_status {
    local bbr_status=$(sysctl net.ipv4.tcp_congestion_control 2>/dev/null | awk '{print $3}')
    if [ "$bbr_status" == "bbr" ]; then
        echo "BBR 当前已启用"
    else
        echo "BBR 未启用"
    fi
}

function enable_bbr {
    if [[ "$os" == *"ubuntu"* ]]; then
        modprobe tcp_bbr
        modprobe fq
        echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
        echo "fq" >> /etc/modules-load.d/modules.conf
        echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
        echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    elif [[ "$os" == *"debian"* ]]; then
        if [ -e "/etc/sysctl.d/99-sysctl.conf" ]; then
            echo "net.core.default_qdisc=fq" >> /etc/sysctl.d/99-sysctl.conf
            echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.d/99-sysctl.conf
        else
            echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
            echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
        fi
    fi

    # 应用新的内核参数
    sysctl -p >/dev/null 2>&1

    echo "BBR 已成功启用，请重新启动系统以应用更改。"
}

PS3="请选择一个选项："
options=("检查 BBR 状态" "启用 BBR" "退出")
select opt in "${options[@]}"; do
    case $opt in
        "检查 BBR 状态")
            check_bbr_status
            ;;
        "启用 BBR")
            enable_bbr
            ;;
        "退出")
            break
            ;;
        *) echo "无效选项 $REPLY";;
    esac
done
