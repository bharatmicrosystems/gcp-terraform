ip_master_01=$1
ip_master_02=$2
ip_master_03=$3
vip=$4
project=$5
mkdir -p /etc/etcd/ssl
mkdir -p /var/lib/etcd
gsutil cp -r gs://staging-${project}/ssl/*.pem /etc/etcd/ssl/
yum install -y wget
wget https://github.com/coreos/etcd/releases/download/v3.3.4/etcd-v3.3.4-linux-amd64.tar.gz
tar -zxvf etcd-v3.3.4-linux-amd64.tar.gz
cp etcd-v3.3.4-linux-amd64/etcd* /usr/local/bin/
cat <<EOF >  /etc/systemd/system/etcd.service
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target
Documentation=https://github.com/coreos
[Service]
Type=notify
WorkingDirectory=/var/lib/etcd/
ExecStart=/usr/local/bin/etcd \
--name=master02 \
--cert-file=/etc/etcd/ssl/etcd.pem \
--key-file=/etc/etcd/ssl/etcd-key.pem \
--peer-cert-file=/etc/etcd/ssl/etcd.pem \
--peer-key-file=/etc/etcd/ssl/etcd-key.pem \
--trusted-ca-file=/etc/etcd/ssl/ca.pem \
--peer-trusted-ca-file=/etc/etcd/ssl/ca.pem \
--initial-advertise-peer-urls=https://ph_ip_master_02:2380 \
--listen-peer-urls=https://ph_ip_master_02:2380 \
--listen-client-urls=https://ph_ip_master_02:2379,http://127.0.0.1:2379 \
--advertise-client-urls=https://ph_ip_master_02:2379 \
--initial-cluster-token=etcd-cluster-0 \
--initial-cluster=master01=https://ph_ip_master_01:2380,master02=https://ph_ip_master_02:2380,master03=https://ph_ip_master_03:2380 \
--initial-cluster-state=new \
--data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF
sed -i "s/ph_ip_master_01/${ip_master_01}/g" /etc/systemd/system/etcd.service
sed -i "s/ph_ip_master_02/${ip_master_02}/g" /etc/systemd/system/etcd.service
sed -i "s/ph_ip_master_03/${ip_master_03}/g" /etc/systemd/system/etcd.service
systemctl daemon-reload && systemctl enable etcd && systemctl start etcd
yum install keepalived -y
cat <<EOF >  /etc/keepalived/keepalived.conf
global_defs {
   router_id LVS_k8s
}
vrrp_script CheckK8sMaster {
    script "curl -k https://ph_ip_master_02:6443"
    interval 3
    timeout 9
    fall 2
    rise 2
}
vrrp_instance VI_1 {
    state BACKUP
    interface eth0
    virtual_router_id 61
    priority 80
    advert_int 1
    mcast_src_ip ph_ip_master_02
    nopreempt
    authentication {
          auth_type PASS
        auth_pass KEEPALIVED_AUTH_PASS
    }
    unicast_peer {
        ph_ip_master_01
        ph_ip_master_03
    }
    virtual_ipaddress {
        ph_vip
    }
    track_script {
        CheckK8sMaster
    }
}
EOF
sed -i "s/ph_ip_master_01/${ip_master_01}/g" /etc/keepalived/keepalived.conf
sed -i "s/ph_ip_master_02/${ip_master_02}/g" /etc/keepalived/keepalived.conf
sed -i "s/ph_ip_master_03/${ip_master_03}/g" /etc/keepalived/keepalived.conf
sed -i "s/ph_vip/${vip}/g" /etc/keepalived/keepalived.conf
systemctl daemon-reload && systemctl enable keepalived && systemctl restart keepalived
gsutil cp -r gs://staging-${project}/pki /etc/kubernetes/
cat <<EOF >  kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta2
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: ph_ip_master_02
---
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
etcd:
  external:
    endpoints:
    - https://ph_ip_master_01:2379
    - https://ph_ip_master_02:2379
    - https://ph_ip_master_03:2379
    caFile: /etc/etcd/ssl/ca.pem
    certFile: /etc/etcd/ssl/etcd.pem
    keyFile: /etc/etcd/ssl/etcd-key.pem
networking:
  podSubnet: 10.244.0.0/16
apiServer:
  certSANs:
  - ph_ip_master_01
  - ph_ip_master_02
  - ph_ip_master_03
  - ph_vip
  extraArgs:
    endpoint-reconciler-type: lease
EOF
sed -i "s/ph_ip_master_01/${ip_master_01}/g" kubeadm-config.yaml
sed -i "s/ph_ip_master_02/${ip_master_02}/g" kubeadm-config.yaml
sed -i "s/ph_ip_master_03/${ip_master_03}/g" kubeadm-config.yaml
sed -i "s/ph_vip/${vip}/g" kubeadm-config.yaml
kubeadm init --config kubeadm-config.yaml
