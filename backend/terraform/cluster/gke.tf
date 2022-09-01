resource "google_container_cluster" "gke01" {
  name     = "${var.prefix}-${var.environment}-gke01"
  location = var.region

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  node_locations           = [var.zone, var.replica_zone]

  network    = var.network_id
  subnetwork = var.subnet_id

  ip_allocation_policy {
    services_secondary_range_name = var.services_ip_range_name
    cluster_secondary_range_name  = var.pods_ip_range_name
  }

  release_channel {
    channel = "REGULAR"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_global_access_config {
      enabled = false
    }
    master_ipv4_cidr_block = "172.16.0.0/28"
  }

  lifecycle {
    ignore_changes = [
      initial_node_count
    ]
  }
}

resource "google_service_account" "nodepoolsa01" {
  account_id   = "nodepool-sa01"
  display_name = "Service Account for ${var.prefix}-${var.environment}-nodepool01"
}

resource "google_container_registry" "asiagcr" {
  location = "ASIA"
}

resource "google_storage_bucket_iam_member" "viewer" {
  bucket = google_container_registry.asiagcr.id
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.nodepoolsa01.email}"
}

resource "google_container_node_pool" "nodepool01" {
  name           = "${var.prefix}-${var.environment}-nodepool01"
  location       = var.region
  cluster        = google_container_cluster.gke01.name
  node_count     = var.node_count
  node_locations = [var.zone, var.replica_zone]

  node_config {
    machine_type = var.machine_type
    disk_type    = "pd-ssd"
    disk_size_gb = 50

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.nodepoolsa01.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    labels = var.labels
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 1
  }

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
}
