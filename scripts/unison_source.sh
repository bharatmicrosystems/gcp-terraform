targetNodeIp=$1
wget https://www.seas.upenn.edu/~bcpierce/unison/download/releases/stable/unison-2.48.4.tar.gz
tar xvfz unison-2.48.4.tar.gz
cd src
yum install ocaml ocaml-camlp4-devel ctags ctags-etags
make
cp -v unison /usr/local/sbin/
cp -v unison /usr/bin
cat <<EOF >  /root/.unison/default.prf
# Unison preferences file
#
repeat = watch
root = /kubevolumes/
root = ssh://root@TARGET_NODE_IP//kubevolumes/root@TARGET_NODE_IP
group=true
owner=true
prefer=newer
times=true  
EOF
sed -i "s/TARGET_NODE_IP/${targetNodeIp}/g" /root/.unison/default.prf
cd ~
curl -L -o unison-fsmonitor https://github.com/TentativeConvert/Syndicator/raw/master/unison-binaries/unison-fsmonitor
cp unison-fsmonitor /usr/local/sbin/
cp unison-fsmonitor /usr/bin/
chmod +x /usr/bin/unison-fsmonitor
chmod +x /usr/local/sbin/unison-fsmonitor
cat <<EOF >  /etc/systemd/system/unison.service
[Unit]
Description=unison Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/unison default
Restart=on-abort


[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable unison
systemctl start unison
systemctl status unison
