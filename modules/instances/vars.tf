variable "instance_name" {}
variable "instance_machine_type" {
  default = "f1-micro"
}
variable "instance_zone" {}
variable "instance_image" {}
variable "subnet_name" {}
variable "external_enabled" {}
variable "startup_script" {}
