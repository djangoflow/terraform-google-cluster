variable "name" {
  type        = string
  description = "Cluster name"
}

variable "location" {
  type        = string
  description = "Cluster location"
  default     = "europe-west4-a"
}

variable "authorized_networks" {
  description = "A map of network_name:cidr of the networks allowed to access this cluster"
  type        = map(string)
  default     = {}
}

variable "network" {
  type = string
}

variable "master_ipv4_cidr_block" {
  default = "172.16.0.0/28"
}

variable "cluster_ipv4_cidr_block" {
  default = "10.44.0.0/14"
}

variable "services_ipv4_cidr_block" {
  default = "10.48.0.0/20"
}

variable "node_pools" {
  type = map(object({
    machine_type   = string
    min_node_count = number
    max_node_count = number
    disk_size_gb   = number
    disk_type      = string
    preemptible    = bool

  }))
  default = {
    "pool-1" : {
      min_node_count = 3
      max_node_count = 0
      disk_size_gb   = 100
      machine_type   = "e2-small"
      disk_type      = "pd-standard"
      preemptible    = true
    }
  }
}

variable "extra_admins" {
  description = "A list of emails of extra cluster admins"
  type        = list(string)
  default     = []
}

variable "extra_oauth_scopes" {
  default     = []
  type        = list(string)
  description = "A list of extra oauth scopes, e.g. https://www.googleapis.com/auth/cloud-platform"
}

variable "default_oauth_scopes" {
  type        = list(string)
  description = "A list of default extra oauth scopes, can be overriden"

  default = [
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/trace.append",
  ]
}
