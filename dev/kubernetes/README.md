# kubernetes
## Setting up a multi-master highly available kubernetes Cluster
This repository contains terraform templates which would spin up infrastucte required for having a multi master kubernetes cluster.

## Setup the infrastucture
Specifications
3 master nodes master01 master02 master_03 on 3 zones of us-central1 region
1 worker node node01 on 1 zone of us-central1 region
1 nginx load balancer to load balance the master api servers and also the nginx ingress controllers running on worker nodes

```
cd dev/kubernetes
cp terraform.tfvars.example terraform.tfvars
```
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
To destroy the terraform objects
```
terraform destroy
```
Note the internal ips of all the nodes and substitute in the placeholders specified

## Setup Load Balancer
ssh into the masterlb node
```
sudo su -
yum install -y git
git clone https://github.com/bharatmicrosystems/gcp-terraform.git
cd gcp-terraform/scripts
sh -x loadbalancer.sh <ip_master_01> <ip_master_02> <ip_master_03> <ip_node_01>
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
ssh into the master02 node
```
sudo su -
yum install -y git
git clone https://github.com/bharatmicrosystems/gcp-terraform.git
cd gcp-terraform/scripts
sh -x master_followers.sh <LOAD_BALANCER_IP> <kubetoken> <kubecacertshash> <kubecertkey>
```
ssh into the master03 node
```
sudo su -
yum install -y git
git clone https://github.com/bharatmicrosystems/gcp-terraform.git
cd gcp-terraform/scripts
sh -x master_followers.sh <LOAD_BALANCER_IP> <kubetoken> <kubecacertshash> <kubecertkey>
```
ssh into the node01 node
```
sudo su -
yum install -y git
git clone https://github.com/bharatmicrosystems/gcp-terraform.git
cd gcp-terraform/scripts
sh -x master_followers.sh <LOAD_BALANCER_IP> <kubetoken> <kubecacertshash>
```
