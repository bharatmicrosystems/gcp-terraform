module "master01" {
  source        = "../../modules/instances"
  instance_name = "master01"
  instance_machine_type = "n1-standard-2"
  instance_zone = "us-central1-a"
  instance_image = "centos-7-v20191014"
  subnet_name = "default"
  external_enabled = "true"
  startup_script = ""
}
module "master02" {
  source        = "../../modules/instances"
  instance_name = "master02"
  instance_machine_type = "n1-standard-2"
  instance_zone = "us-central1-b"
  instance_image = "centos-7-v20191014"
  subnet_name = "default"
  external_enabled = "true"
  startup_script = ""
}
module "master03" {
  source        = "../../modules/instances"
  instance_name = "master03"
  instance_machine_type = "n1-standard-2"
  instance_zone = "us-central1-c"
  instance_image = "centos-7-v20191014"
  subnet_name = "default"
  external_enabled = "true"
  startup_script = ""
}

module "node01" {
  source        = "../../modules/instances"
  instance_name = "node01"
  instance_machine_type = "n1-standard-2"
  instance_zone = "us-central1-a"
  instance_image = "centos-7-v20191014"
  subnet_name = "default"
  external_enabled = "true"
  startup_script = ""
}

module "node02" {
  source        = "../../modules/instances"
  instance_name = "node02"
  instance_machine_type = "n1-standard-2"
  instance_zone = "us-central1-b"
  instance_image = "centos-7-v20191014"
  subnet_name = "default"
  external_enabled = "true"
  startup_script = ""
}
