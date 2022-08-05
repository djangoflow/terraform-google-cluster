data "google_client_config" "google" {}

resource "google_container_cluster" "cluster" {
  name                  = var.name
  network               = var.network
  location              = var.location
  enable_shielded_nodes = true

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.cluster_ipv4_cidr_block
    services_ipv4_cidr_block = var.services_ipv4_cidr_block
  }

  remove_default_node_pool = true
  initial_node_count       = 1

  workload_identity_config {
    workload_pool = "${data.google_client_config.google.project}.svc.id.goog"
  }

  addons_config {
    http_load_balancing {
      disabled = true
    }
    network_policy_config {
      disabled = true
    }
  }

  default_snat_status {
    disabled = true
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.authorized_networks
      iterator = cidr
      content {
        cidr_block   = cidr.value
        display_name = cidr.key
      }
    }
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }
}
