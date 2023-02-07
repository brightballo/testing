## Dependencies
- Install terraform
- Connect gcloud
```bash 
gcloud auth login
gcloud config set project <project-name>
gcloud auth application-default login 
```
- Replace terraform providers (this is because we need a different version)
```bash
terraform state replace-provider registry.terraform.io/-/google registry.terraform.io/hashicorp/google
```
```bash
terraform state replace-provider registry.terraform.io/-/helm registry.terraform.io/hashicorp/helm
```