#Setting up NGINX Ingress controller
kubectl apply -f mandatory.yaml
kubectl apply -f service-nodeport.yaml
kubectl get all -n ingress-nginx
