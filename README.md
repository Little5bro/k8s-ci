# Use Ansible Deploy a Kubernetes Cluster

The project utilize ansible to deploy a kubernetes cluster with some virtual machine nodes that is created by Vagrant. You can utilize [Vagrantfile](Vagrantfile) or [Vagrantfile.local](Vagrantfile.local) to create your vm nodes. but note that [extend-disk.sh](extend-disk.sh) Using in `Vagrantfile` may not working for you. and replace the `vm.box` with your Vagrant box, when creating VMs.

The project only adopted to Testing and Pre-production. Not using in production environment.

## Prerequisites

- Vagrant version >= 2.2.4
- Ansible version >= 2.8.5
- A host that have Ansible installed
- More than 2 VM nodes with CentOS7 OS created by Vagrant
- VMs have 2 cpus and 2048MB memory minimally
- VMs have NET Devices that can access each other
- online when deploy Kubernetes cluster

## Kubernetes Cluster Deploy Procedure

### Create Your VMs

Create your VMs with Vagrant, there is no statement here. refer to [Vagrant Docs](https://www.vagrantup.com/docs/index.html).

### Modify and Customize

Applications supported by this project:

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

After VMs have been created, modify `ansible_host` and `ansible_password` in [inventory.yml](inventory.yml), and add or delete nodes on the basis of your conditions. Please hold the hostname `k8s-master` and the other same as hostname setting in `Vagrantfile` or `Vagrantfile.local`.

There are some components deployed in Kubernetes Cluster, you can choose them by modifying [application.yml](application.yml). you must select `calico`, `helm`, `nfs-client-provisioner` and `rook-ceph`, otherwise, some errors occurred. Here is some attentions below, select that interest you.

After you complete modifying and customizing applications, run command in host installed with ansible:

```bash
ansible-playbook -i inventory.yml kubernetes.yml
```

#### calico

Modify item `IP_AUTODETECTION_METHOD` of Daemonset in [calico.yaml](roles/calico/files/calico.yaml). The reason is that Vagrant create a default net device named `eth0`, if you use `Vagrantfile` of this project created your VMs. `eth0` is used for connecting VMs with the host, not used between VMs. you should modify the value of `IP_AUTODETECTION_METHOD` with `interface=eth1`, or other net devices that can connect all your VM nodes.

#### dashboard

The project deploy the dashboard to master of Kubernetes cluster simply, and expose service to port 8443 of master. Modify `nodeSelector: kubernetes.io/hostname` of Deployment in [kubernetes-dashboard.yaml](roles/dashboard/files/kubernetes-dashboard.yaml) with your exact hostname of master, modify `spec.containers.ports.hostPort` with another port, if 8443 is occupied.

Access dashboard web with url as: `https://<k8s-master-ip>:8443`.

#### flannel

As calico, modify `spec.containers.args` of daemonset in file [kube-flannel.yml](roles/flannel/files/kube-flannel.yml) with adding item `--iface=eth1` or other net devices.
