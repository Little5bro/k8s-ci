# 使用 Ansible 部署 Kubernetes 集群

使用 Ansible 在 Vagrant 创建的一些虚拟机节点上部署一个 Kubernetes 集群。你可以使用这里提供的 [Vagrantfile](Vagrantfile) 和 [Vagrantfile.local](Vagrantfile.local) 创建虚拟机。但是要注意 `Vagrantfile` 中的 [extend-disk.sh](extend-disk.sh) 可能并不适用于你的 Vagrant box。创建虚拟机时，用你使用的 Vagrant box 替换 `Vagrantfile` 中的 `vm.box`。

本项目仅用于测试和预生产环境。不可使用在生产环境中。

## 前提条件

- Vagrant 版本 >= 2.2.4
- Ansible 版本 >= 2.8.5
- 一台安装有 Ansible 的主机
- 2台以上的使用 Vagrant 创建的 CentOS7 系统虚拟机
- 所有虚拟机需要有至少 2 CPUs, 2048MB 内存
- 所有虚拟机要添加网络设备用于相互通信
- 安装 Kubernetes 集群时保持联网

## 部署过程

### 创建虚拟机

如何使用 Vagrant 创建虚拟机不在此处说明，请参考 [Vagrant Docs](https://www.vagrantup.com/docs/index.html)。

### 修改与定制

此项目目前支持的应用如下：

- Calico
- Dashboard
- Elasticsearch and kibana
- Flannel
- Flink session cluster
- Helm
- Jupyter notbook
- Kafka
- Mongodb sidecar
- nfs-client-provisioner
- rook-ceph
- traefik ingress controller
- zeppelin

创建 vm 之后，在 [inventory](inventory.yml) 中修改 `ansible_host` 和 `ansible_password`。并根据您的条件添加或删除节点。请保持主机名 `k8s-master` 和其他节点主机名 与 `Vagrantfile` 或 `Vagrantfile.local` 中设置的主机名相同。

Kubernetes 集群中部署了一些组件，您可以通过修改 [application.yml](application.yml) 来选择它们。必选的有 `calico`, `helm`, `nfs-client-provisioner` 和 `rook-ceph`，否则部署时会发生错误。以下是一些注意事项，请按需求选择。

在完成修改与定制之后，在安装有 Ansible 的主机中运行一下命令：

```bash
ansible-playbook -i inventory.yml kubernetes.yml
```

#### calico

修改 [calico.yaml](roles/calico/files/calico.yaml) 文件 Daemonset 中的 `IP_AUTODETECTION_METHOD` 字段。原因是 Vagrant 在虚拟机中创建默认的 `eth0` 网卡用于连接虚拟机与主机，而不是用于虚拟机之间的通信。用你自己设置的用于虚拟机相互连接的网卡名修改 `IP_AUTODETECTION_METHOD` 字段的值，例如 `interface=eth1` 。

#### dashboard

此项目简单地在 Kubernetes 集群的主节点部署 dashboard，并在主节点的 8443 端口暴露服务。用你自己设置的主节点的主机名修改 [kubernetes-dashboard.yaml](roles/dashboard/files/kubernetes-dashboard.yaml) 文件的 Deployment 中的 `nodeSelector: kubernetes.io/hostname` 字段，如果 主节点的 8443 端口被占用的话，使用空闲的端口修改 `spec.containers.ports.hostPort` 。

完成部署后，在浏览器中输入 `https://<k8s-master-ip>:8443` 以访问 Kubernetes Dashboard。

#### flannel

和 calico 相同， 需要修改 [kube-flannel.yml](roles/flannel/files/kube-flannel.yml) 文件 daemonset 的 `spec.containers.args`，添加 `--iface=eth1` 参数，此处的主机名根据你自己的情况而定。

以上，如果你使用此项目默认的 `Vagrantfile` 或者 `Vagrantfile.local` 创建虚拟机，不需要修改，保持默认即可。
