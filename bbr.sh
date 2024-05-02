#!/bin/bash

while true; do
    echo "请选择您要执行的操作："
    echo "1. 检测BBR状态"
    echo "2. 开启BBR（BBR FQ）"
    echo "3. 退出脚本"
    read choice

    case $choice in
        1)
            echo "正在检测BBR状态..."
            sudo sysctl net.ipv4.tcp_congestion_control | grep bbr
            ;;
        2)
            echo "正在开启BBR（BBR FQ）..."
            sudo modprobe tcp_bbr
            sudo sh -c 'echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf'
            sudo sh -c 'echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf'
            sudo sysctl -p
            echo "BBR（BBR FQ）已开启"
            ;;
        3)
            echo "退出脚本"
            exit 0
            ;;
        *)
            echo "无效的选项，请重新选择"
            ;;
    esac
done
