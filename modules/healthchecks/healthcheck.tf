resource "google_compute_health_check" "main" {
  name                = "${var.name}"
  check_interval_sec  = "${var.check_interval_sec}"
  timeout_sec         = "${var.timeout_sec}"
  healthy_threshold   = "${var.healthy_threshold}"
  unhealthy_threshold = "${var.unhealthy_threshold}"                         # 50 seconds

  http_health_check {
    request_path = "${var.request_path}"
    port         = "${var.port}"
  }
}

output "self_link" {
  value = "${google_compute_health_check.main.self_link}"
}
