// network.tf variables

variable "vpc_name" {}
variable "subnet_name1" {}
variable "subnet_ip_cidr_range1" {}
variable "subnet_region1" {}
variable "subnet_name2" {}
variable "subnet_ip_cidr_range2" {}
variable "subnet_region2" {}

// instance.tf variables
variable "instance_name" {}
variable "instance_machine_type" {}
variable "instance_zone" {}
variable "instance_image" {}

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

variable "kube_name" {}
variable "kube_location" {}
variable "kube_subnetwork" {}
variable "kube_node_pool_name" {}
variable "kube_node_count" {}
variable "kube_preemptible" {}
