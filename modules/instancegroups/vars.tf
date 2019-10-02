variable "igm_name" {}
variable "base_instance_name" {}
variable "instance_template_self_link" {}
variable "instance_machine_type" {
  default = "f1-micro"
}
variable "update_strategy" {}
variable "initial_delay_sec" {}
variable "target_size" {}
variable "health_check" {}
variable "zone" {}
