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
  default = "Standard_B2s"
}
variable "vm_count" {
  type    = number
  default = 2
}
