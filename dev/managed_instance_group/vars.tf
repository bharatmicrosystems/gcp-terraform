//managed_instance_group.tf variables

variable "health_check_name" {}
variable "check_interval_sec" {}
variable "timeout_sec" {}
variable "healthy_threshold" {}
variable "unhealthy_threshold" {}
variable "request_path" {}
variable "port" {}
variable "instance_template_name" {}
variable "instance_template_machine_type" {}
variable "instance_group_zone" {}
variable "source_image" {}
variable "auto_delete" {}
variable "metadata_startup_script" {}
variable "subnetwork" {}
variable "igm_name" {}
variable "base_instance_name" {}
variable "update_strategy" {}
variable "target_size" {}
variable "initial_delay_sec" {}
variable "instance_template_region" {}
