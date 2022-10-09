resource "google_service_account" "vm_sa01" {
  account_id   = "vm-sa01"
  display_name = "Service Account for ${var.prefix}-${var.environment}-vm01"
}

resource "google_compute_instance" "vm01" {
  name                      = "${var.prefix}-${var.environment}-vm01"
  machine_type              = var.machine_type_vm
  zone                      = var.zone
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.image_vm
      type  = "pd-standard"
      size  = 50
    }
  }

  network_interface {
    subnetwork = var.subnet_id

    access_config {
      # Ephemeral public IP
    }
  }

  shielded_instance_config {
    enable_secure_boot = false
  }

  advanced_machine_features {
    enable_nested_virtualization = false
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.vm_sa01.email
    scopes = ["cloud-platform"]
  }

  tags = ["${var.prefix}-${var.environment}-vm01"]

  labels = var.labels
}

resource "google_compute_firewall" "webhook_firewallrule" {
  name        = "${google_compute_instance.vm01.name}-ssh"
  network     = var.network_id
  description = "Port 22"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.ssh_ip]
  target_tags   = google_compute_instance.vm01.tags
}
