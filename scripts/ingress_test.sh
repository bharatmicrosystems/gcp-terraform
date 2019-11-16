#Testing the ingress controller
IC_IP=$1
IC_HTTP_PORT=80
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 LOAD_BALANCER_IP" >&2
  exit 1
fi
kubectl apply -f apple.yaml
kubectl apply -f banana.yaml
kubectl apply -f ingress.yaml
kubectl get nodes -o wide
sleep 15
curl -kL http://$IC_IP:$IC_HTTP_PORT/apple
curl -kL http://$IC_IP:$IC_HTTP_PORT/banana
