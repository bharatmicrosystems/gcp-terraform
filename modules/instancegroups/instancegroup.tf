resource "google_compute_instance_group_manager" "main" {
  name = "${var.igm_name}"

  base_instance_name = "${var.base_instance_name}"
  instance_template  = "${var.instance_template_self_link}"
  update_strategy    = "${var.update_strategy}"
  zone = "${var.zone}"
  target_size  = "${var.target_size}"

  auto_healing_policies {
    health_check      = "${var.health_check}"
    initial_delay_sec = "${var.initial_delay_sec}"
  }
}
