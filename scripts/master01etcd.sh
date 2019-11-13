ip_master_01=$1
ip_master_02=$2
ip_master_03=$3
#Do this on all master nodes
mkdir -p /etc/etcd/ssl
mkdir -p /var/lib/etcd
gsutil cp -r gs://staging-1144/ssl/*.pem /etc/etcd/ssl/
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
--name=master01 \
--cert-file=/etc/etcd/ssl/etcd.pem \
--key-file=/etc/etcd/ssl/etcd-key.pem \
--peer-cert-file=/etc/etcd/ssl/etcd.pem \
--peer-key-file=/etc/etcd/ssl/etcd-key.pem \
--trusted-ca-file=/etc/etcd/ssl/ca.pem \
--peer-trusted-ca-file=/etc/etcd/ssl/ca.pem \
--initial-advertise-peer-urls=https://ph_ip_master_01:2380 \
--listen-peer-urls=https://ph_ip_master_01:2380 \
--listen-client-urls=https://ph_ip_master_01:2379,http://127.0.0.1:2379 \
--advertise-client-urls=https://ph_ip_master_01:2379 \
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
