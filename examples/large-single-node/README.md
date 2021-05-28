# Large Single Node Example

This example creates a large 16vCPU single node cluster. This is useful when you are testing applications in a local mode. I.e. Pachyderm, with no remote storage.

## Usage

```bash
cd examples/large-single-node
echo 'gcp_project_id = "your-gcp-project-id"' > settings.auto.tfvars
terraform init
terraform apply
```