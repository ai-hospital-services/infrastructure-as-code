resource "google_compute_region_disk" "wordpressdisk01" {
  name = "${var.prefix}-${var.environment}-wordpressdisk01"
  type = "pd-ssd"
  size = 10

  region        = var.region
  replica_zones = [var.zone, var.replica_zone]
  labels        = var.labels

  lifecycle {
    ignore_changes = [labels]
  }
}

resource "google_compute_region_disk" "mysqldisk01" {
  name = "${var.prefix}-${var.environment}-mysqldisk01"
  type = "pd-ssd"
  size = 10

  region        = var.region
  replica_zones = [var.zone, var.replica_zone]
  labels        = var.labels

  lifecycle {
    ignore_changes = [labels]
  }
}

resource "google_compute_region_disk" "mongodbdisk01" {
  name = "${var.prefix}-${var.environment}-mongodbdisk01"
  type = "pd-ssd"
  size = 10

  region        = var.region
  replica_zones = [var.zone, var.replica_zone]
  labels        = var.labels

  lifecycle {
    ignore_changes = [labels]
  }
}
