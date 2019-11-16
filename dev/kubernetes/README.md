# Setting up a multi-master Highly Available Kubernetes Cluster on CentOS7
This repository contains terraform templates which would spin up infrastructure required for having a multi master kubernetes cluster and scripts needed to setup the cluster. If you are running on-premise you can skip the terraform part and use the scripts to setup the cluster in your environment.

## Setup the infrastructure
Specifications

3 master nodes master01 master02 master03 on 3 DCs for HA

1 worker node node01 on one DC. You may need to add multiple nodes in that case just follow the steps as mentioned.

1 nginx load balancer to load balance the master api servers and also the nginx ingress controllers running on worker nodes

If you choose to use the terraform templates for creating the environment on google cloud platform follow the steps below. If you are running on-premise you would need to provision the infrastructure yourself.

Ensure that all nodes can talk to each other on the internal ip on all ports.
```
cd dev/kubernetes
cp terraform.tfvars.example terraform.tfvars
```
Edit instance.tf to add more worker nodes/modify configuration if necessary
Edit terraform.tfvars to add your custom configuration

Initialize, Validate and Plan your configuration
```
terraform init
terraform plan
terraform validate
```

To create the terraform objects
```
terraform apply
```
Note the internal ips of all the nodes and substitute in the placeholders specified

## Setup Load Balancer

ssh into the masterlb node
```
sudo su -
yum install -y git
git clone https://github.com/bharatmicrosystems/gcp-terraform.git
cd gcp-terraform/scripts
```
If you are setting up more than one worker node, ensure that you edit the nginx.conf file and add additional worker nodes in the load balancer configuration as suggested in the file in the below section. You can start by uncommenting ip_node_02 and ip_node_03 and adding further nodes here
```
upstream stream_node_backend_80 {
    server ip_node_01:80;
    #server ip_node_02:80;
    #server ip_node_03:80;
    # ...
}
```
If you are setting up more than one worker node, you would also have to edit the loadbalancer.sh file to replace the ip_node_02 and ip_node_03 with the node IPs. Uncomment the args area of the script and the sed area of the script as suggested and add further lines as necessary
```
ip_master_01=$1
ip_master_02=$2
ip_master_03=$3
ip_node_01=$4
#ip_node_02=$5
#ip_node_03=$6
# ...

sed -i "s/ip_node_01/${ip_node_01}/g" /etc/nginx/nginx.conf
#sed -i "s/ip_node_02/${ip_node_02}/g" /etc/nginx/nginx.conf
#sed -i "s/ip_node_03/${ip_node_03}/g" /etc/nginx/nginx.conf
# ...
```
Once you have modified everything run the following
```
sh -x loadbalancer.sh <ip_master_01> <ip_master_02> <ip_master_03> <ip_node_01> <ip_node_02> ...
```
## Setup Kubernetes
ssh into the master01 node
```
sudo su -
yum install -y git
git clone https://github.com/bharatmicrosystems/gcp-terraform.git
cd gcp-terraform/scripts
sh -x master_leader.sh <LOAD_BALANCER_IP>
```
If everything is ok you would get a message like below
```
You can now join any number of the control-plane node running the following command on each as root:

  kubeadm join masterlb:6443 --token hwe4u6.hy79bfq4uq3myhsn \
    --discovery-token-ca-cert-hash sha256:7b437ae3463c1236e29f30dc9c222f65f818d304f8b410b598451478240f105a \
    --control-plane --certificate-key b38664ca2d82e7e4969a107b45d2be83767606331590d7b487eaad1ddbe8cd26

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join masterlb:6443 --token hwe4u6.hy79bfq4uq3myhsn \
    --discovery-token-ca-cert-hash sha256:7b437ae3463c1236e29f30dc9c222f65f818d304f8b410b598451478240f105a
```
Copy this in the notepad as we will use it later on

We would now attempt to join the master02 node as an additional control plane. Refer to the section below from the text you copied to notepad and make a note of --token,  --discovery-token-ca-cert-hash and --certificate-key values as we would be using them in the commands that follow
```
kubeadm join masterlb:6443 --token hwe4u6.hy79bfq4uq3myhsn \
  --discovery-token-ca-cert-hash sha256:7b437ae3463c1236e29f30dc9c222f65f818d304f8b410b598451478240f105a \
  --control-plane --certificate-key b38664ca2d82e7e4969a107b45d2be83767606331590d7b487eaad1ddbe8cd26
```
ssh into the master02 node
```
sudo su -
yum install -y git
git clone https://github.com/bharatmicrosystems/gcp-terraform.git
cd gcp-terraform/scripts
sh -x master_followers.sh <LOAD_BALANCER_IP> <kubetoken> <discovery-token-ca-cert-hash> <certificate-key>
```
ssh into the master03 node
```
sudo su -
yum install -y git
git clone https://github.com/bharatmicrosystems/gcp-terraform.git
cd gcp-terraform/scripts
sh -x master_followers.sh <LOAD_BALANCER_IP> <kubetoken> <discovery-token-ca-cert-hash> <certificate-key>
```
ssh into the worker nodes and execute the following
```
sudo su -
yum install -y git
git clone https://github.com/bharatmicrosystems/gcp-terraform.git
cd gcp-terraform/scripts
sh -x worker.sh <LOAD_BALANCER_IP> <kubetoken> <discovery-token-ca-cert-hash>
```
## Setup Nginx Ingress Controller on the cluster
An Nginx Ingress controller would help us route and manage traffic within the kubernetes cluster and would be a means to expose your workloads externally using Ingress service.

On the master01 node
```
sh -x nginx_ingress.sh
```
Test the ingress Setup
```
sh -x ingress_test.sh <LOAD_BALANCER_IP>
```
You should get an output like the below
```
apple
banana
```
Congratulations! You are all setup!

## Cleaning up
You might want to destroy the objects at the end especially if you are learning and have the infrastructure temporarily setup. To destroy the terraform objects on your terraform workspace run
```
terraform destroy
```
