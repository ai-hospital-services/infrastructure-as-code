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
  services_ip_range_name = module.network.services_ip_range_name
  pods_ip_range_name     = module.network.pods_ip_range_name
  machine_type           = var.machine_type
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
