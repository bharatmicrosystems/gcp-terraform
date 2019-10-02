variable "name" {}
variable "machine_type" {
  default = "f1-micro"
}
variable "source_image" {}
variable "auto_delete" {
  default = false
}
variable "subnetwork" {}
variable "metadata_startup_script"{}
variable "region" {}
