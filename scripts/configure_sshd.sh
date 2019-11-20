#On node 1
ssh-keygen -t rsa
cat /root/.ssh/id_rsa.pub
#One node 2
vim /root/.ssh/authorized_keys
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys
sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config;
systemctl restart sshd
