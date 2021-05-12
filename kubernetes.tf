terraform {
  required_version = "~> 0.15"
}

# https://www.terraform.io/docs/providers/google/index.html
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

module "vpc" {
  source       = "terraform-google-modules/network/google"
  project_id   = var.gcp_project_id
  network_name = var.vpc_network_name

  subnets = [
    {
      subnet_name           = var.vpc_subnetwork_name
      subnet_ip             = var.vpc_subnetwork_cidr_range
      subnet_region         = var.gcp_region
      subnet_private_access = true
    }
  ]

  secondary_ranges = {
    "${var.vpc_subnetwork_name}" = [
      {
        range_name    = var.cluster_secondary_range_name
        ip_cidr_range = var.cluster_secondary_range_cidr
      },
      {
        range_name    = var.services_secondary_range_name
        ip_cidr_range = var.services_secondary_range_cidr
      },
    ]
  }


  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    }
  ]
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id                 = var.gcp_project_id
  name                       = var.cluster_name
  regional                   = var.regional
  region                     = var.gcp_region
  zones                      = var.gcp_zones
  network                    = var.vpc_network_name
  subnetwork                 = var.vpc_subnetwork_name
  ip_range_pods              = var.cluster_secondary_range_name
  ip_range_services          = var.services_secondary_range_name
  http_load_balancing        = false
  horizontal_pod_autoscaling = false
  network_policy             = false
  remove_default_node_pool   = true
  node_pools                 = var.node_pools
  issue_client_certificate   = var.client_certificate_enabled
  enable_private_nodes       = true
  enable_private_endpoint    = false
}

module "router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 0.1"

  name    = "prod-router"
  project = var.gcp_project_id
  region  = var.gcp_region
  network = module.vpc.network_self_link
}

module "nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 1.2"
  project_id = var.gcp_project_id
  region     = var.gcp_region
  router     = module.router.router.name
}
