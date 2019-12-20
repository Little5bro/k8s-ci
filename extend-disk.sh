#!/bin/bash
# 此脚本仅适用于使用CentOS7-base.box的Vagrantfile调用，不同的box可能无法适用

timedatectl set-timezone Asia/Shanghai
#yum install -y epel-release
yum install -y net-tools
# ssh login with passwd
sed -i '/PasswordAuthentication no/s/no/yes/g' /etc/ssh/sshd_config

echo -e "\e[32mInfo: Resize VM disk...\e[0m"

# 获取LVM卷组
VOLGROUP=$(vgs|sed -n 2p|awk {'print $1'})
# 获取根目录的逻辑卷
LVPATH=$(df /|sed -n 2p|awk {'print $1'})

#新建sda4分区
fdisk /dev/sda <<EOF
n
p


t

8e
w
EOF

# 重读分区表
partprobe
# 新建物理卷
pvcreate /dev/sda4
# 将新建的物理卷加入卷组
vgextend ${VOLGROUP} /dev/sda4
# 扩展逻辑卷空间
lvextend -l +100%FREE ${LVPATH}
#重设逻辑卷空间
xfs_growfs ${LVPATH}

