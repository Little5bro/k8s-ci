# -*- mode: ruby -*-
# vi: set ft=ruby :

# 安装vagrant-disksize插件重设磁盘大小：vagrant plugin install vagrant-disksize

Vagrant.configure("2") do |config|
  
  (1..3).each do |i|

    ipnum = 212 + i
    config.vm.define "node#{i}" do |node|
    node.vm.box = "CentOS7-base"
    node.vm.box_check_update = false
    node.vm.network "public_network", bridge: "em1", ip: "10.0.0.#{ipnum}"
    node.disksize.size="100GB"

    node.vm.provider "virtualbox" do |vb|
      vb.cpus=2
      vb.memory = "2048"
    end

    node.vm.provision "shell", path: "extend-disk.sh"
      
    end
  end
end
