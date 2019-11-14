yum install -y telnet ngnix
cp nginx.conf /etc/nginx/nginx.conf
setenforce 0
sed -i 's/enforcing/permissive/g' /etc/selinux/config
systemctl enable nginx
systemctl start nginx
