# terraform-google-kubernetes

Combinator infrastructure module that creates a Kubernetes cluster in Google Cloud Platform, powered by Google Kubernetes Engine.

## Usage

Please note that you need a GCP account and project in order to use this module. The following represents the minimal configuration and creates the cheapest GKE cluster available.

```terraform
module "terraform-google-kubernetes" {
  source  = "combinator-ml/kubernetes/google"
  gcp_project_id = "your-gpc-project-id"
}
```

There are several examples that provide different functionality. For example there are minimal low-cost and cheap(est) cpu-autoscaling versions. See the [examples directory](examples) for more information.

See the full configuration options below.

### Costs

By default, this runs in a single zone, which means it falls under GCP's free management tier and you don't have to pay for management nodes, only worker nodes. After the first zone you pay, and that's when it gets expensive. See the [GCP pricing pages](https://cloud.google.com/kubernetes-engine/pricing#cluster_management_fee_and_free_tier) for more information.

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.15 |

## Providers

| Name | Version |
|------|---------|
| google | n/a |
| random | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| gke | terraform-google-modules/kubernetes-engine/google//modules/private-cluster |  |
| nat | terraform-google-modules/cloud-nat/google | ~> 1.2 |
| router | terraform-google-modules/cloud-router/google | ~> 0.1 |
| vpc | terraform-google-modules/network/google |  |

## Resources

| Name |
|------|
| [google_project_iam_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) |
| [google_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) |
| [random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| gcp\_project\_id | The ID of the project in which the resources belong. | `string` | n/a | yes |
| access\_private\_images | Whether to create the IAM role for storage.objectViewer, required to access<br>GCR for private container images. | `string` | `"false"` | no |
| client\_certificate\_enabled | Enables the creation of a client certificate.<br>This is required if you want to connect from Gitlab. | `string` | `"true"` | no |
| cluster\_name | The name of the cluster, unique within the project and zone. | `string` | `"combinator"` | no |
| cluster\_secondary\_range\_cidr | CIDR range for pods | `string` | `"10.16.0.0/12"` | no |
| cluster\_secondary\_range\_name | The name of the secondary range to be used as for the cluster CIDR block.<br>The secondary range will be used for pod IP addresses. This must be an<br>existing secondary range associated with the cluster subnetwork. | `string` | `"combinator-pod-cidr"` | no |
| daily\_maintenance\_window\_start\_time | The start time of the 4 hour window for daily maintenance operations RFC3339<br>format HH:MM, where HH : [00-23] and MM : [00-59] GMT. | `string` | `"03:00"` | no |
| gcp\_region | GCP region | `string` | `"europe-west1"` | no |
| gcp\_zones | GCP zone | `list(string)` | <pre>[<br>  "europe-west1-d"<br>]</pre> | no |
| http\_load\_balancing\_disabled | The status of the HTTP (L7) load balancing controller addon, which makes it<br>easy to set up HTTP load balancers for services in a cluster. It is enabled<br>by default; set disabled = true to disable. | `string` | `"false"` | no |
| master\_authorized\_networks\_cidr\_blocks | Defines up to 20 external networks that can access Kubernetes master<br>through HTTPS. | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "display_name": "default"<br>  }<br>]</pre> | no |
| master\_ipv4\_cidr\_block | The IP range in CIDR notation to use for the hosted master network. This<br>range will be used for assigning internal IP addresses to the master or set<br>of masters, as well as the ILB VIP. This range must not overlap with any<br>other ranges in use within the cluster's network. | `string` | `"172.16.0.0/28"` | no |
| network\_policy\_enabled | Enables the NetworkPolicy feature. | `string` | `"false"` | no |
| node\_pools | The list of node pool configurations, each should include:<br>name - The name of the node pool, which will be suffixed with '-pool'.<br>Defaults to pool number in the Terraform list, starting from 1.<br>initial\_node\_count - The initial node count for the pool. Changing this will<br>force recreation of the resource. Defaults to 1.<br>autoscaling\_min\_node\_count - Minimum number of nodes in the NodePool. Must be<br>>=0 and <= max\_node\_count. Defaults to 2.<br>autoscaling\_max\_node\_count - Maximum number of nodes in the NodePool. Must be<br>>= min\_node\_count. Defaults to 3.<br>management\_auto\_repair - Whether the nodes will be automatically repaired.<br>Defaults to 'true'.<br>management\_auto\_upgrade - Whether the nodes will be automatically upgraded.<br>Defaults to 'true'.<br>node\_config\_machine\_type - The name of a Google Compute Engine machine type.<br>Defaults to n1-standard-1. To create a custom machine type, value should be<br>set as specified here:<br>https://cloud.google.com/compute/docs/reference/rest/v1/instances#machineType<br>node\_config\_disk\_type - Type of the disk attached to each node (e.g.<br>'pd-standard' or 'pd-ssd'). Defaults to 'pd-standard'<br>node\_config\_disk\_size\_gb - Size of the disk attached to each node, specified<br>in GB. The smallest allowed disk size is 10GB. Defaults to 100GB.<br>node\_config\_preemptible - Whether or not the underlying node VMs are<br>preemptible. See the official documentation for more information. Defaults to<br>false. https://cloud.google.com/kubernetes-engine/docs/how-to/preemptible-vms | `list(map(string))` | <pre>[<br>  {<br>    "auto_repair": true,<br>    "disk_size_gb": 30,<br>    "disk_type": "pd-standard",<br>    "image_type": "COS",<br>    "local_ssd_count": 0,<br>    "machine_type": "e2-medium",<br>    "max_count": 1,<br>    "min_count": 1,<br>    "name": "default",<br>    "preemptible": true<br>  }<br>]</pre> | no |
| regional | Regional clusters (set true) have masters in multiple regions but are more expensive.<br>Zonal clusters (set false) are cheaper (free for your first one) but are not redundant. | `bool` | `false` | no |
| services\_secondary\_range\_cidr | CIDR range for services | `string` | `"10.1.0.0/20"` | no |
| services\_secondary\_range\_name | The name of the secondary range to be used as for the services CIDR block.<br>The secondary range will be used for service ClusterIPs. This must be an<br>existing secondary range associated with the cluster subnetwork. | `string` | `"combinator-services-cidr"` | no |
| vpc\_network\_name | The name of the Google Compute Engine network to which the cluster is<br>connected. | `string` | `"combinator-network"` | no |
| vpc\_subnetwork\_cidr\_range | CIDR range for node subnet | `string` | `"10.0.16.0/20"` | no |
| vpc\_subnetwork\_name | The name of the Google Compute Engine subnetwork in which the cluster's<br>instances are launched. | `string` | `"combinator-subnetwork"` | no |

## Outputs

No output.
