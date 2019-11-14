#Testing the ingress controller
IC_IP=$1
IC_HTTPS_PORT=443
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 LOAD_BALANCER_IP" >&2
  exit 1
fi
cd ../examples/complete-example/
kubectl create -f cafe.yaml
kubectl create -f cafe-secret.yaml
kubectl create -f cafe-ingress.yaml
kubectl get all
curl --resolve cafe.example.com:$IC_HTTPS_PORT:$IC_IP https://cafe.example.com:$IC_HTTPS_PORT/coffee --insecure
