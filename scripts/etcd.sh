ip_master_01=$1
ip_master_02=$2
ip_master_03=$3
project=$4
curl -o /usr/local/bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
curl -o /usr/local/bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x /usr/local/bin/cfssl*

mkdir /opt/ssl

cat <<EOF >  /opt/ssl/ca-config.json
{
  "signing": {
    "default": {
      "expiry": "87600h"
    },
    "profiles": {
      "kubernetes": {
        "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ],
        "expiry": "87600h"
      }
    }
  }
}
EOF

cat <<EOF >  /opt/ssl/ca-csr.json
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "ST": "TX",
      "L": "dallas",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF

cat <<EOF >  /opt/ssl/etcd-csr.json
{
      "CN": "etcd",
  "hosts": [
    "127.0.0.1",
    "ip_master_01",
    "ip_master_02",
    "ip_master_03"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "ST": "TX",
      "L": "dallas",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF
sed -i "s/ip_master_01/${ip_master_01}/g" /opt/ssl/etcd-csr.json
sed -i "s/ip_master_02/${ip_master_02}/g" /opt/ssl/etcd-csr.json
sed -i "s/ip_master_03/${ip_master_03}/g" /opt/ssl/etcd-csr.json
cat /opt/ssl/etcd-csr.json
cd /opt/ssl/
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes etcd-csr.json | cfssljson -bare etcd
gsutil cp -r /opt/ssl gs://staging-${project}
