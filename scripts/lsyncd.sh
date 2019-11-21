#https://www.scalescale.com/tips/nginx/lsyncd-live-file-syncronization-linux/#
targetNodeIp=$1
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 TARGET_NODE_IP" >&2
  exit 1
fi
yum -y install epel-release
yum -y install lua lua-devel pkgconfig gcc asciidoc
yum install -y lsyncd
systemctl start lsyncd
chkconfig lsyncd on
mkdir /var/log/lsyncd
cat <<EOF >  /etc/lsyncd.conf
settings {
logfile = "/var/log/lsyncd/lsyncd.log",
statusFile = "/var/log/lsyncd/lsyncd-status.log",
statusInterval = 10
}

-- Slave server configuration

sync {
default.rsync,
source="/kubevolumes",
target="TARGET_NODE_IP:/kubevolumes",
delay = 0,
rsync = {
compress = true,
acls = true,
verbose = true,
owner = true,
group = true,
perms = true,
rsh = "/usr/bin/ssh -p 22 -o StrictHostKeyChecking=no"
}
}
EOF
sed -i "s/TARGET_NODE_IP/${targetNodeIp}/g" /etc/lsyncd.conf
systemctl restart lsyncd
