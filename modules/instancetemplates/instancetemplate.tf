resource "google_compute_instance_template" "main" {

  name         = "${var.name}"
  machine_type = "${var.machine_type}"
  // Create a new boot disk from an image
  disk {
    source_image = "${var.source_image}"
    auto_delete  = "${var.auto_delete}"
    boot         = true
  }

  metadata_startup_script = "${var.metadata_startup_script}"

  network_interface {
    subnetwork = "${var.subnetwork}"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  region = "${var.region}"


}

output "self_link" {
  value = "${google_compute_instance_template.main.self_link}"
}
