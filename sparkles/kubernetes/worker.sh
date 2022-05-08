#! /bin/bash
# guide is from https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

# PS Install docker first. use wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/docker.sh

# Install / Enable iscsi initiator for openEBS.
systemctl enable --now iscsid


# prepare some things.
modprobe br_netfilter
lsmod | grep br_netfilter

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

# Step 2
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system


# Step 3, change cgroupdriver for docker, restart docker.
cat <<EOF | sudo tee /etc/docker/daemon.json
{
    "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

systemctl restart docker

# Step 4, get repo list and key

curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list



# Step 5, update and install some more

apt-get update
apt-get install -y apt-transport-https ca-certificates curl

# Step 6, install kubeadm and kubelet.
apt install kubeadm kubelet -y
systemctl enable --now kubelet

cat <<EOF | sudo tee /etc/containerd/config.toml

#   Copyright 2018-2022 Docker Inc.

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#       http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


#disabled_plugins = ["cri"]

#root = "/var/lib/containerd"
#state = "/run/containerd"
#subreaper = true
#oom_score = 0

#[grpc]
#  address = "/run/containerd/containerd.sock"
#  uid = 0
#  gid = 0

#[debug]
#  address = "/run/containerd/debug.sock"
#  uid = 0
#  gid = 0
#  level = "info"
EOF


# Ready to join cluster. 

echo "run kubeadm token create --print-join-command on kube-master to get join token"
echo "Check if new node is online with kubectl get nodes"
