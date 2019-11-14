ip_master_01=$1
ip_master_02=$2
ip_master_03=$3
ip_node_01=$4

if [ "$#" -ne 4 ]; then
  echo "Usage: $0 ip_master_01 ip_master_02 ip_master_03 ip_node_01" >&2
  exit 1
fi
yum install -y telnet ngnix
cp nginx.conf /etc/nginx/nginx.conf
sed -i "s/ip_master_01/${ip_master_01}/g" /etc/nginx/nginx.conf
sed -i "s/ip_master_02/${ip_master_02}/g" /etc/nginx/nginx.conf
sed -i "s/ip_master_03/${ip_master_03}/g" /etc/nginx/nginx.conf
sed -i "s/ip_node_01/${ip_node_01}/g" /etc/nginx/nginx.conf
setenforce 0
sed -i 's/enforcing/permissive/g' /etc/selinux/config
systemctl enable nginx
systemctl start nginx
