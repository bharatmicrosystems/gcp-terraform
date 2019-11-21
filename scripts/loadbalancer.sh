ip_master_01=$1
ip_master_02=$2
ip_master_03=$3
ip_node_01=$4
#ip_node_02=$5
#ip_node_03=$6
# ...
if [ "$#" -lt 4 ]; then
  echo "Usage: $0 ip_master_01 ip_master_02 ip_master_03 ip_node_01 ..." >&2
  exit 1
fi
rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
yum install -y telnet nginx
cp nginx.conf /etc/nginx/nginx.conf
sed -i "s/ip_master_01/${ip_master_01}/g" /etc/nginx/nginx.conf
sed -i "s/ip_master_02/${ip_master_02}/g" /etc/nginx/nginx.conf
sed -i "s/ip_master_03/${ip_master_03}/g" /etc/nginx/nginx.conf
sed -i "s/ip_node_01/${ip_node_01}/g" /etc/nginx/nginx.conf
#sed -i "s/ip_node_02/${ip_node_02}/g" /etc/nginx/nginx.conf
#sed -i "s/ip_node_03/${ip_node_03}/g" /etc/nginx/nginx.conf
# ...
setenforce 0
sed -i 's/enforcing/permissive/g' /etc/selinux/config
systemctl enable nginx
systemctl start nginx
