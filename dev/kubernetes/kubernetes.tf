module "my-kube-cluster" {
  source        = "../../modules/kubecluster"
  name = "${var.kube_name}"
  location = "${var.kube_location}"
  network  = "${var.vpc_name}"
  subnetwork = "${var.kube_subnetwork}"
}
module "node-pool1" {
  source        = "../../modules/kubenodepool"
  name = "${var.kube_node_pool_name}"
  node_count = "${var.kube_node_count}"
  preemptible = "${var.kube_preemptible}"
  location = "${var.kube_location}"
  cluster = "${module.my-kube-cluster.kube_cluster_name}"
}
