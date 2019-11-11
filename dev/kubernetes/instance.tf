module "kube-master" {
  source        = "../../modules/instances"
  instance_name = "kube-master"
  instance_machine_type = "n1-standard-2"
  instance_zone = "us-central1-a"
  instance_image = "ubuntu-1804-bionic-v20191021"
  subnet_name = "default"
  external_enabled = "true"
}

module "kube-worker-1" {
  source        = "../../modules/instances"
  instance_name = "kube-worker-1"
  instance_machine_type = "n1-standard-2"
  instance_zone = "us-central1-a"
  instance_image = "ubuntu-1804-bionic-v20191021"
  subnet_name = "default"
  external_enabled = "true"
}

module "kube-worker-2" {
  source        = "../../modules/instances"
  instance_name = "kube-worker-2"
  instance_machine_type = "n1-standard-2"
  instance_zone = "us-central1-a"
  instance_image = "ubuntu-1804-bionic-v20191021"
  subnet_name = "default"
  external_enabled = "true"
}
