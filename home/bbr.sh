#!/bin/bash

# 脚本版本号
VERSION="1.0.0"

while true; do
    echo "BBR脚本版本号：$VERSION"
    echo "请选择您要执行的操作："
    echo "1. 检测BBR状态"
    echo "2. 开启BBR（BBR FQ）"
    echo "3. 退出脚本"
    read -p "请输入相应数字：" choice

    case $choice in
        1)
            echo "正在检测BBR状态..."
            bbr_status=$(sysctl net.ipv4.tcp_congestion_control | awk -F "=" '{print $2}' | tr -d '[:space:]')
            if [ "$bbr_status" == "bbr" ]; then
                echo "BBR已开启"
            else
                echo "BBR未开启"
            fi
            ;;
        2)
            echo "正在开启BBR（BBR FQ）..."
            sudo modprobe tcp_bbr
            sudo sh -c 'echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf'
            sudo sh -c 'echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf'
            sudo sysctl -p
            echo "BBR（BBR FQ）已开启"

            # 询问是否重启以使BBR生效
            read -p "是否想要重启以使BBR生效？(Y/N)：" restart_choice
            case $restart_choice in
                [Yy])
                    echo "正在重启系统..."
                    sudo reboot
                    ;;
                [Nn])
                    echo "请手动重启系统以使BBR生效"
                    ;;
                *)
                    echo "无效的选项，默认为不重启"
                    ;;
            esac
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
