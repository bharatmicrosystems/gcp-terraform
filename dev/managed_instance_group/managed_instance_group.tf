module "health-check" {
  source      = "../modules/healthchecks"
  name                = "${var.health_check_name}"
  check_interval_sec  = "${var.check_interval_sec}"
  timeout_sec         = "${var.timeout_sec}"
  healthy_threshold   = "${var.healthy_threshold}"
  unhealthy_threshold = "${var.unhealthy_threshold}"
  request_path = "${var.request_path}"
  port         = "${var.port}"
}

module "instance-template"{
  source      = "../modules/instancetemplates"
  name         = "${var.instance_template_name}"
  machine_type = "${var.instance_template_machine_type}"
  source_image = "${var.source_image}"
  auto_delete  = "${var.auto_delete}"
  metadata_startup_script = "${var.metadata_startup_script}"
  subnetwork = "${var.subnetwork}"
  region = "${var.instance_template_region}"
}

module "instance-group"{
  source      = "../modules/instancegroups"
  zone               = "${var.instance_group_zone}"
  igm_name = "${var.igm_name}"
  base_instance_name = "${var.base_instance_name}"
  instance_template_self_link  = "${module.instance-template.self_link}"
  update_strategy    = "${var.update_strategy}"
  target_size  = "${var.target_size}"
  health_check      = "${module.health-check.self_link}"
  initial_delay_sec = "${var.initial_delay_sec}"
}
