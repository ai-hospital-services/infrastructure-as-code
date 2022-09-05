variable "project_id" {
  default = ""
}
variable "region" {
  default = "asia-south1"
}
variable "zone" {
  default = "asia-south1-a"
}
variable "replica_zone" {
  default = "asia-south1-b"
}
variable "prefix" {
  default = "ai-hospital-svcs"
}
variable "environment" {
  default = "prototype"
}
variable "machine_type_pool01" {
  default = "e2-small"
}
variable "machine_type_pool02" {
  default = "t2a-standard-1"
}
variable "node_count" {
  type    = number
  default = 1
}