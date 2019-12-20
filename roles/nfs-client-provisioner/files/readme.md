# 安装nfs服务器

## 在210 k8s-master 上安装 nfs 服务器

```bash
yum install -y nfs-utils rpcbind

mkdir -p /opt/share
chmod a+w /opt/share

echo "/opt/share *(rw,async,no_root_squash)" >> /etc/exports
exportfs -r

systemctl enable rpcbind
systemctl start rpcbind

systemctl enable nfs-server
systemctl start nfs-server
```
