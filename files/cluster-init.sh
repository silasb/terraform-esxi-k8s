#!/bin/bash

role=$1
version=$2

CNI_VERSION="v0.7.5"
mkdir -p /opt/cni/bin
curl -L "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-amd64-${CNI_VERSION}.tgz" | tar -C /opt/cni/bin -xz

CRICTL_VERSION="v1.12.0"
mkdir -p /opt/bin
curl -L "https://github.com/kubernetes-incubator/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-amd64.tar.gz" | tar -C /opt/bin -xz

RELEASE="$(curl -sSL https://dl.k8s.io/release/stable-$version.txt)"

mkdir -p /opt/bin
cd /opt/bin
curl -L --remote-name-all https://storage.googleapis.com/kubernetes-release/release/${RELEASE}/bin/linux/amd64/{kubeadm,kubelet,kubectl}
chmod +x {kubeadm,kubelet,kubectl}

curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/debs/kubelet.service" | sed "s:/usr/bin:/opt/bin:g" > /etc/systemd/system/kubelet.service
mkdir -p /etc/systemd/system/kubelet.service.d
curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/debs/10-kubeadm.conf" | sed "s:/usr/bin:/opt/bin:g" > /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

systemctl enable --now kubelet

systemctl daemon-reload
systemctl restart kubelet

export PATH=$PATH:/opt/bin

echo "DEBUG: role ${role}" 1>&2

if [[ "$role" = "master" ]]; then
	kubeadm config images pull
	kubeadm init --pod-network-cidr=192.168.0.0/22

	mkdir -p ~core/.kube
	cp -i /etc/kubernetes/admin.conf ~core/.kube/config
	chown core:core ~core/.kube/config

	export KUBECONFIG=/etc/kubernetes/admin.conf
	kubectl apply -f https://docs.projectcalico.org/v3.7/manifests/calico.yaml

	# openEBS
	# kubectl apply -f https://openebs.github.io/charts/openebs-operator-0.8.0.yaml

	# single machine kube cluster
	# kubectl taint nodes --all node-role.kubernetes.io/master-
	# kubectl label node kube1-workers-1 node-role.kubernetes.io/worker=worker

	echo "kubeadm token create --print-join-command"
fi

if [[ "$role" == "worker" ]]; then
	master_ip=$2
	echo "DEBUG: master_ip ${master_ip}" 1>&2
	token=$3
	echo "DEBUG: token ${token}" 1>&2
	ca_cert_sha=$4
	echo "DEBUG: ca_cert_sha ${ca_cert_sha}" 1>&2

	systemctl enable docker.service

	kubeadm join $master_ip:6443 --token $token --discovery-token-ca-cert-hash sha256:$ca_cert_sha
fi
