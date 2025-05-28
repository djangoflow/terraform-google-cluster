resource "google_container_node_pool" "node_pool" {
  depends_on = [google_container_cluster.cluster]
  for_each = var.node_pools
  name     = each.key
  location = var.location
  cluster  = var.name

  initial_node_count = each.value.min_node_count
  max_pods_per_node  = var.max_pods_per_node
  dynamic "autoscaling" {
    for_each = each.value.max_node_count > each.value.min_node_count ? [1] : []
    content {
      min_node_count = each.value.min_node_count
      max_node_count = each.value.max_node_count
    }
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    resource_labels = {
      "goog-gke-node-pool-provisioning-model" = "spot"
    }
    tags = []

    kubelet_config {
      cpu_cfs_quota      = false
      pod_pids_limit     = 0
      cpu_manager_policy = "none"
    }

    image_type   = "COS_containerd"
    machine_type = each.value.machine_type

    disk_size_gb = each.value.disk_size_gb
    disk_type    = each.value.disk_type
    preemptible  = each.value.preemptible

    metadata = {
      "disable-legacy-endpoints" = "true"
    }

    oauth_scopes = concat(var.default_oauth_scopes, var.extra_oauth_scopes)

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    dynamic "guest_accelerator" {
      for_each = each.value.guest_accelerator != null ? [each.value.guest_accelerator] : []
      content {
        type  = guest_accelerator.value.type
        count = guest_accelerator.value.count

        dynamic "gpu_sharing_config" {
          for_each = guest_accelerator.value.gpu_sharing_config != null ? [guest_accelerator.value.gpu_sharing_config] : []
          content {
            gpu_sharing_strategy       = gpu_sharing_config.value.gpu_sharing_strategy
            max_shared_clients_per_gpu = gpu_sharing_config.value.max_shared_clients_per_gpu
          }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      initial_node_count, node_config["resource_labels"]
    ]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}
