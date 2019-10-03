resource "google_container_node_pool" "main" {
  name       = "${var.name}"
  region   = "${var.location}"
  cluster    = "${var.cluster}"
  node_count = "${var.node_count}"

  node_config {
    preemptible  = "${var.preemptible}"
    machine_type = "${var.machine_type}"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}
