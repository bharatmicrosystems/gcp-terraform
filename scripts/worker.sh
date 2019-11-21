LOAD_BALANCER_IP=$1
kubetoken=$2
kubecacertshash=$3
cat <<EOF > /etc/yum.repos.d/centos.repo
[centos]
name=CentOS-7
baseurl=http://ftp.heanet.ie/pub/centos/7/os/x86_64/
enabled=1
gpgcheck=1
gpgkey=http://ftp.heanet.ie/pub/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7
#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras
baseurl=http://ftp.heanet.ie/pub/centos/7/extras/x86_64/
enabled=1
gpgcheck=0
EOF
yum -y update
yum -y install docker
systemctl enable docker
systemctl start docker

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
setenforce 0
sed -i 's/enforcing/permissive/g' /etc/selinux/config
yum -y install kubelet kubeadm kubectl
systemctl start kubelet
systemctl enable kubelet

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
echo 1 > /proc/sys/net/ipv4/ip_forward
cat <<EOF >> /etc/hosts
masterlb_ip masterlb
EOF
sed -i "s/masterlb_ip/${LOAD_BALANCER_IP}/g" /etc/hosts
swapoff -a
kubeadm join masterlb:6443 --token ${kubetoken} --discovery-token-ca-cert-hash ${kubecacertshash}
