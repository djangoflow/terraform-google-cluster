output "ca_certificate" {
  value = base64decode(
    google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
  )
}

output "token" {
  value = data.google_client_config.google.access_token
}

output "host" {
  value = "https://${google_container_cluster.cluster.endpoint}"
}

output "private_host" {
  value = "https://${google_container_cluster.cluster.private_cluster_config.0.private_endpoint}"
}
