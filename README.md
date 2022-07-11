## DevOps Playground

> There is a set of things that you could do in order to prepare start preparing yourself for your role.

- Try to deploy NATS using their official helm charts to some k8s cluster
- Try to build your own helm charts for some custom image and use it to deploy to some example k8s cluster
- Write a terraform script that will create an public ACR + AKS on Azure Cloud
- Write a CD using github actions that will deploy an image to ACR
- Deploy ArgoCD with a concept of app-of-apps to AKS
- Deploy Grafana Loki and configure it for NATS, and start gathering logs
- Configure ArgoCD to deploy custom app using your previously created helm charts to AKS you have created with terraform and downloading the image from ACR you created



## Common fixes
### Cached Terraform
```bash 
git filter-branch -f --index-filter 'git rm --cached -r --ignore-unmatch .terraform/'
```
