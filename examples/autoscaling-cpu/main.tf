variable "gcp_project_id" {
  default = "your-gcp-project-id"
}

module "kubernetes" {
  source         = "combinator-ml/kubernetes/google"
  gcp_project_id = var.gcp_project_id
  node_pools = [
    {
      name            = "default"
      machine_type    = "e2-medium"
      min_count       = 1 # Nodes per zone! Must be at least 1 to host system pods
      max_count       = 10
      local_ssd_count = 0
      disk_size_gb    = 30
      disk_type       = "pd-standard"
      image_type      = "COS"
      auto_repair     = true
      preemptible     = true
    }
  ]
}
