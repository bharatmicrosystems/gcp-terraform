resource "google_storage_bucket" "file-store" {
  name     = "file-store-${var.project}"
}
module "kube-master" {
  source        = "../../modules/instances"
  instance_name = "kube-master"
  instance_machine_type = "n1-standard-2"
  instance_zone = "us-central1-a"
  instance_image = "ubuntu-1804-bionic-v20191021"
  subnet_name = "default"
  external_enabled = "true"
  startup_script = "sudo apt-get update; sudo apt-get install -y wget; wget https://raw.githubusercontent.com/bharatmicrosystems/gcp-terraform/master/dev/master.sh; sh master.sh > master.log; gsutil cp master.log ${google_storage_bucket.file-store.url}"
}

module "kube-worker-1" {
  source        = "../../modules/instances"
  instance_name = "kube-worker-1"
  instance_machine_type = "n1-standard-2"
  instance_zone = "us-central1-a"
  instance_image = "ubuntu-1804-bionic-v20191021"
  subnet_name = "default"
  external_enabled = "true"
  startup_script = "sudo apt-get update; sudo apt-get install -y wget; wget https://raw.githubusercontent.com/bharatmicrosystems/gcp-terraform/master/dev/worker.sh; sh worker.sh > worker.log"
}

module "kube-worker-2" {
  source        = "../../modules/instances"
  instance_name = "kube-worker-2"
  instance_machine_type = "n1-standard-2"
  instance_zone = "us-central1-a"
  instance_image = "ubuntu-1804-bionic-v20191021"
  subnet_name = "default"
  external_enabled = "true"
  startup_script = "sudo apt-get update; sudo apt-get install -y wget; wget https://raw.githubusercontent.com/bharatmicrosystems/gcp-terraform/master/dev/worker.sh; sh worker.sh > worker.log"
}
