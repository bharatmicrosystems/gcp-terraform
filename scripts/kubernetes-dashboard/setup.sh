dashboardDomain=$1
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 DASHBOARD_DOMAIN" >&2
  exit 1
fi
mkdir $HOME/certs
cd $HOME/certs/
openssl genrsa -out dashboard.key 2048
openssl rsa -in dashboard.key -out dashboard.key
openssl req -sha256 -new -key dashboard.key -out dashboard.csr -subj "/CN=${dashboardDomain}"
openssl x509 -req -sha256 -days 365 -in dashboard.csr -signkey dashboard.key -out dashboard.crt
kubectl create ns "kubernetes-dashboard"
kubectl -n kubernetes-dashboard create secret generic kubernetes-dashboard-certs --from-file=$HOME/certs
kubectl apply -f recommended.yaml
kubectl -n kubernetes-dashboard get all
sed -i "s/DASHBOARD_DOMAIN/${dashboardDomain}/g" kubernetes-dashboard-in.yaml
kubectl apply -f kubernetes-dashboard-in.yaml
kubectl apply -f dashboard-sa.yaml
kubectl apply -f dashboard-crb.yaml
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
