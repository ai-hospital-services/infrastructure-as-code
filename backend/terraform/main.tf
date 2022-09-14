locals {
  labels = {
    managed-by = "terraform"
  }
}

module "network" {
  source      = "./network"
  providers   = { google = google.default }
  labels      = local.labels
  region      = var.region
  zone        = var.zone
  prefix      = var.prefix
  environment = var.environment
}

module "cluster" {
  source                 = "./cluster"
  providers              = { google = google.default }
  labels                 = local.labels
  region                 = var.region
  zone                   = var.zone
  replica_zone           = var.replica_zone
  prefix                 = var.prefix
  environment            = var.environment
  network_id             = module.network.network01_id
  subnet_id              = module.network.subnet01_id
  master_ip_range        = module.network.master_ip_range
  services_ip_range_name = module.network.services_ip_range_name
  pods_ip_range_name     = module.network.pods_ip_range_name
  machine_type_pool01    = var.machine_type_pool01
  machine_type_pool02    = var.machine_type_pool02
  node_count             = var.node_count

  depends_on = [module.network]
}

module "storage" {
  source       = "./storage"
  providers    = { google = google.default }
  labels       = local.labels
  region       = var.region
  zone         = var.zone
  replica_zone = var.replica_zone
  prefix       = var.prefix
  environment  = var.environment
}