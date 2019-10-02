variable "name" {}
variable "check_interval_sec" {
  default = 5
}
variable "timeout_sec" {
  default = 5
}
variable "healthy_threshold" {
  default = 2
}
variable "unhealthy_threshold" {
  default = 10
}
variable "request_path" {
  default = "/"
}
variable "port" {
  default = "80"
}
