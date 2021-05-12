variable "gcp_project_id" {}

module "kubernetes" {
  source         = "../../"
  gcp_project_id = var.gcp_project_id
}
