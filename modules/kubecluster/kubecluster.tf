resource "google_container_cluster" "main" {
  name     = "${var.name}"
  region = "${var.location}"
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 1
  network  = "${var.network}"
  subnetwork = "${var.subnetwork}"

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}

output "kube_cluster_name" {
  value = "${google_container_cluster.main.name}"
}
