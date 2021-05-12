variable "gcp_project_id" {
  default = "your-gcp-project-id"
}

module "kubernetes" {
  source         = "combinator-ml/kubernetes/google"
  gcp_project_id = var.gcp_project_id
}
