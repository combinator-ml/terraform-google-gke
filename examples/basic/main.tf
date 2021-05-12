variable "gcp_project_id" {}

module "kubernetes" {
  source         = "combinator-ml/kubernetes/google"
  gcp_project_id = var.gcp_project_id
}
