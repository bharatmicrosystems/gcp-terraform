variable "name" {}
variable "machine_type" {
  default = "f1-micro"
}
variable "location" {}
variable "cluster" {}
variable "node_count" {
  default = 1
}
variable "preemptible" {
  default = false
}
