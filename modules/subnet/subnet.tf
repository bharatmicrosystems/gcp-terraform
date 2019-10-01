resource "google_compute_subnetwork" "main" {
  name          = "${var.subnet_name}"
  ip_cidr_range = "${var.subnet_ip_cidr_range}"
  region        = "${var.subnet_region}"
  network       = "${var.network_self_link}"
}

output "subnet_self_link" {
  value = "${google_compute_subnetwork.main.self_link}"
}

output "subnet_name" {
  value = "${google_compute_subnetwork.main.name}"
}
