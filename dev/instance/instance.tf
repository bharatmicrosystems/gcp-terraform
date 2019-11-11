module "my-instance" {
  source        = "../../modules/instances"
  instance_name = "${var.instance_name}"
  instance_machine_type = "${var.instance_machine_type}"
  instance_zone = "${var.instance_zone}"
  instance_image = "${var.instance_image}"
  subnet_name = "${var.subnet_name}"
  external_enabled = "${var.external_enabled}"
}
