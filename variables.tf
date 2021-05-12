variable "gcp_project_id" {
  type        = string
  description = <<EOF
The ID of the project in which the resources belong.
EOF
}

variable "cluster_name" {
  type        = string
  default     = "combinator"
  description = <<EOF
The name of the cluster, unique within the project and zone.
EOF
}

variable "gcp_region" {
  type        = string
  default     = "europe-west1"
  description = "GCP region"
}

variable "gcp_zones" {
  type        = list(string)
  default     = ["europe-west1-d"]
  description = "GCP zone"
}

variable "daily_maintenance_window_start_time" {
  type        = string
  default     = "03:00"
  description = <<EOF
The start time of the 4 hour window for daily maintenance operations RFC3339
format HH:MM, where HH : [00-23] and MM : [00-59] GMT.
EOF
}

variable "node_pools" {
  type = list(map(string))
  default = [
    {
      name            = "default"
      machine_type    = "e2-medium"
      min_count       = 1 # Nodes per zone! Must be at least 1 to host system pods
      max_count       = 1
      local_ssd_count = 0
      disk_size_gb    = 30
      disk_type       = "pd-standard"
      image_type      = "COS"
      auto_repair     = true
      preemptible     = true
    }
  ]
  description = <<EOF
The list of node pool configurations, each should include:
name - The name of the node pool, which will be suffixed with '-pool'.
Defaults to pool number in the Terraform list, starting from 1.
initial_node_count - The initial node count for the pool. Changing this will
force recreation of the resource. Defaults to 1.
autoscaling_min_node_count - Minimum number of nodes in the NodePool. Must be
>=0 and <= max_node_count. Defaults to 2.
autoscaling_max_node_count - Maximum number of nodes in the NodePool. Must be
>= min_node_count. Defaults to 3.
management_auto_repair - Whether the nodes will be automatically repaired.
Defaults to 'true'.
management_auto_upgrade - Whether the nodes will be automatically upgraded.
Defaults to 'true'.
node_config_machine_type - The name of a Google Compute Engine machine type.
Defaults to n1-standard-1. To create a custom machine type, value should be
set as specified here:
https://cloud.google.com/compute/docs/reference/rest/v1/instances#machineType
node_config_disk_type - Type of the disk attached to each node (e.g.
'pd-standard' or 'pd-ssd'). Defaults to 'pd-standard'
node_config_disk_size_gb - Size of the disk attached to each node, specified
in GB. The smallest allowed disk size is 10GB. Defaults to 100GB.
node_config_preemptible - Whether or not the underlying node VMs are
preemptible. See the official documentation for more information. Defaults to
false. https://cloud.google.com/kubernetes-engine/docs/how-to/preemptible-vms
EOF
}

variable "vpc_network_name" {
  type        = string
  default     = "combinator-network"
  description = <<EOF
The name of the Google Compute Engine network to which the cluster is
connected.
EOF
}

variable "vpc_subnetwork_name" {
  type        = string
  default     = "combinator-subnetwork"
  description = <<EOF
The name of the Google Compute Engine subnetwork in which the cluster's
instances are launched.
EOF
}

variable "vpc_subnetwork_cidr_range" {
  type        = string
  default     = "10.0.16.0/20"
  description = "CIDR range for node subnet"
}

variable "cluster_secondary_range_name" {
  type        = string
  default     = "combinator-pod-cidr"
  description = <<EOF
The name of the secondary range to be used as for the cluster CIDR block.
The secondary range will be used for pod IP addresses. This must be an
existing secondary range associated with the cluster subnetwork.
EOF
}

variable "cluster_secondary_range_cidr" {
  type        = string
  default     = "10.16.0.0/12"
  description = "CIDR range for pods"
}

variable "services_secondary_range_name" {
  type        = string
  default     = "combinator-services-cidr"
  description = <<EOF
The name of the secondary range to be used as for the services CIDR block.
The secondary range will be used for service ClusterIPs. This must be an
existing secondary range associated with the cluster subnetwork.
EOF
}

variable "services_secondary_range_cidr" {
  type        = string
  default     = "10.1.0.0/20"
  description = "CIDR range for services"
}

variable "master_ipv4_cidr_block" {
  type        = string
  default     = "172.16.0.0/28"
  description = <<EOF
The IP range in CIDR notation to use for the hosted master network. This
range will be used for assigning internal IP addresses to the master or set
of masters, as well as the ILB VIP. This range must not overlap with any
other ranges in use within the cluster's network.
EOF
}

variable "access_private_images" {
  type        = string
  default     = "false"
  description = <<EOF
Whether to create the IAM role for storage.objectViewer, required to access
GCR for private container images.
EOF
}

variable "http_load_balancing_disabled" {
  type        = string
  default     = "false"
  description = <<EOF
The status of the HTTP (L7) load balancing controller addon, which makes it
easy to set up HTTP load balancers for services in a cluster. It is enabled
by default; set disabled = true to disable.
EOF
}

variable "master_authorized_networks_cidr_blocks" {
  type = list(map(string))
  default = [
    {
      # External network that can access Kubernetes master through HTTPS. Must
      # be specified in CIDR notation. This block should allow access from any
      # address, but is given explicitly to prevernt Google's defaults from
      # fighting with Terraform.
      cidr_block = "0.0.0.0/0"
      # Field for users to identify CIDR blocks.
      display_name = "default"
    },
  ]
  description = <<EOF
Defines up to 20 external networks that can access Kubernetes master
through HTTPS.
EOF
}

variable "network_policy_enabled" {
  type        = string
  default     = "false"
  description = <<EOF
Enables the NetworkPolicy feature.
EOF
}

variable "client_certificate_enabled" {
  type        = string
  default     = "true"
  description = <<EOF
Enables the creation of a client certificate.
This is required if you want to connect from Gitlab.
EOF
}

variable "regional" {
  type        = bool
  default     = false
  description = <<EOF
Regional clusters (set true) have masters in multiple regions but are more expensive.
Zonal clusters (set false) are cheaper (free for your first one) but are not redundant.
EOF
}
