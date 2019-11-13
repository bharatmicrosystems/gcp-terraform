#Setting up NGINX Ingress controller
#Reference link
#https://www.nginx.com/products/nginx/kubernetes-ingress-controller/#:~:targetText=The%20NGINX%20Ingress%20Controller%20for%20Kubernetes%20is%20what%20enables%20Kubernetes,for%20load%20balancing%20Kubernetes%20services.&targetText=The%20following%20example.yml%20file,request%20URI%20and%20Host%20header.
#https://github.com/nginxinc/kubernetes-ingress/
#https://github.com/nginxinc/kubernetes-ingress/blob/master/docs/installation.md
yum install -y git
git clone https://github.com/nginxinc/kubernetes-ingress.git
cd kubernetes-ingress/deployments/
kubectl apply -f common/ns-and-sa.yaml
kubectl apply -f common/default-server-secret.yaml
kubectl apply -f common/nginx-config.yaml
kubectl apply -f rbac/rbac.yaml
kubectl apply -f daemon-set/nginx-ingress.yaml
kubectl get pods --namespace=nginx-ingress -o wide
curl http://10.44.0.1
curl http://10.36.0.1
curl https://10.36.0.1 --insecure
#Testing the ingress controller
IC_IP=10.36.0.1
IC_HTTPS_PORT=443
cd ../examples/complete-example/
kubectl create -f cafe.yaml
kubectl create -f cafe-secret.yaml
kubectl create -f cafe-ingress.yaml
kubectl get all
curl --resolve cafe.example.com:$IC_HTTPS_PORT:$IC_IP https://cafe.example.com:$IC_HTTPS_PORT/coffee --insecure
