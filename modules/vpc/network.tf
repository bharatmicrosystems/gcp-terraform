resource "google_compute_network" "main" {
  name = "${var.vpc_name}"
  auto_create_subnetworks = false
}

output "network_self_link" {
  value = "${google_compute_network.main.self_link}"
}

output "vpc_name" {
  value = "${google_compute_network.main.name}"
}
