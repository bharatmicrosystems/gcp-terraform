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

## Setting up persistent volume mounts

On every node we need to create directories where persistent data can be mounted from containers running on pod. In the next step we will setup replication between the mounts on all servers.

```
sudo mkdir /kubevolumes
```

You can now create subdirectories within /mnt and mount volumes into the subdirectories from the containers.

## Nginx example with persistent volume volume

We would run an nginx deployment and expose that as a NodePort service. The data would be mounted on one of the volumes '/kubevolumes/nginx_data' as a host path volume.

```
sudo mkdir /kubevolumes/nginx_data
sudo sh -c "echo 'Hello from Kubernetes storage' > /kubevolumes/nginx_data/index.html"
cd example-stateful-app/
kubectl apply -f nginx-pv.yaml
kubectl apply -f nginx-pvc.yaml
kubectl apply -f nginx.yaml
kubectl apply -f nginx-in.yaml
curl http://masterlb_ip/nginx
```

## Setting up unison

Running stateful applications within multiple nodes might be an issue as they bind to a PersistentVolume. We are going to use unison in order to sync up the volumes across nodes so that we get High Availability just in case we lose an entire data center

The sync up would be from node01 -> node02 ....-> node0n -> node01

Follow all steps as specified in configure_ssh.sh in order to setup passwordless connectivity between the nodes according to the direction specified above

After that on node01
```
sh -x unison_source.sh <ip_node_02>
```

On node02
```
sh -x unison_source.sh <ip_node_0n>
```

On node0n
```
sh -x unison_target.sh
```
This would ensure that any changes to files on mount of node01 would be replicated on node02 and from node02 to node0n and from node0n to node01.

Make a change to the /mnt/nginx_data/index.html and see it replicated across all the nodes and enjoy!

##Setting up Kubernetes Dashboard

On master run
```
cd gcp-terraform\scripts\kubernetes-dashboard
sh -x setup.sh DASHBOARD_DOMAIN
```
The setup script is going to generate certificate, key and csr of the supplied DASHBOARD_DOMAIN and would create a kubernetes secret file with them. The secret file would then be applied to the dashboard so that they run using the provided cert and key pairs. You can choose to edit the setup.sh file and add your own certs in the secret.

The script then creates a cluster role with the name admin and applies a ClusterRoleBinding to it with cluster-admin privileges. You may wish to control the permissions granually and allow only the required accesses.

This would also expose the kubernetes dashboard on the ingress controller using the provided domain.

The dashboard would be accessible on https://DASHBOARD_DOMAIN if everything runs smoothly.

##Setting up metrics server
Metrics server is necessary for the horizonal pod autoscaler and prometheus to work. The following are the steps to install the metrics server


Edit config map to make hostfile entries of all your nodes
```
kubectl edit configmap coredns -n kube-system
```
```
       errors
       health
       hosts {
         x.x.x.x master01
         x.x.x.x master02
         x.x.x.x node01
         x.x.x.x node02
         x.x.x.x node03
         fallthrough
       }
       ready
       kubernetes cluster.local in-addr.arpa ip6.arpa {

```

Install the metrics server
```
kubectl apply -f scripts/metrics-server/deploy/1.8+/
kubectl top nodes
```

##Install prometheus and grafana
prometheus and grafana are popular open source monitoring and alerting solution and can be used to monitor the kubernetes cluster.

```
kubectl create ns monitoring
kubectl apply -f scripts/prometheus-grafana/grafana-pv.yaml
kubectl apply -f scripts/prometheus-grafana/grafana-pvc.yaml
kubectl apply -f scripts/prometheus-grafana/manifests-all.yaml
kubectl apply -f scripts/prometheus-grafana/ingress.yaml
```
You can now access prometheus on prometheus.localhost and grafana on grafana.localhost
Login on grafana using the default admin/admin creds

## Cleaning up
You might want to destroy the objects at the end especially if you are learning and have the infrastructure temporarily setup. To destroy the terraform objects on your terraform workspace run
```
terraform destroy
```
