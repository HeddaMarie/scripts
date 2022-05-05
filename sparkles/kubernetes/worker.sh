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

# Ready to join cluster. 

echo "run kubeadm token create --print-join-command on kube-master to get join token"
echo "Check if new node is online with kubectl get nodes"
