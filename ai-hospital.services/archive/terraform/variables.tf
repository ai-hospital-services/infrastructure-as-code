variable "subscription_id" {
  default = ""
}
variable "tenant_id" {
  default = ""
}
variable "client_id" {
  default = ""
}
variable "client_secret" {
  default = ""
}
variable "prefix" {
  default = "cloud-hospital"
}
variable "environment" {
  default = "web"
}
variable "location" {
  default = "centralindia"
}
variable "vm_size" {
  default = "standard_d2a_v4"
}
variable "vm_min_count" {
  type    = number
  default = 2
}
variable "vm_max_count" {
  type    = number
  default = 5
}
