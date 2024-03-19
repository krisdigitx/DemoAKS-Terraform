# DemoAKS-Terraform

# AKS + ACR with Managed Identity

This template deploys an Azure Kubernetes Service cluster with a user-assigned Identity along with an Azure Container Registry.  The identity of the AKS cluster has an assigned reader role to the ACR instance so AKS can pull containers without needing to have a Docker username and password configured.

## Variables

| Name | Description |
|-|-|
| name | Name of the deployment |
| environment | The depolyment environment name (used for postfixing resource names) |
| location | The Azure Region to deploy these resources in |
| vm_sku | The SKU of the VMs to deploy for AKS |
| dns_prefix | A DNS Prefix to use in the AKS Cluster |


## Create backend storage for terraform state

```
#!/bin/bash

RESOURCE_GROUP_NAME=devopsdemoxyz-dev-rg
STORAGE_ACCOUNT_NAME=tfstatetfstatedemodevxyz
CONTAINER_NAME=tfstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location WestUS2

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

```

Run the following commands to get the storage access key and store it as an environment variable:


```
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
export ARM_ACCESS_KEY=$ACCOUNT_KEY
```

### Install ArgoCD on AKS
```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get all -n argocd
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

# Attach ACR to AKS using using acr-name
```
az aks update -n demo-devApp-aks -g demo-devApp-mongoose-dev-rg --attach-acr ddademodevAppmongooseacr
```

OR

# Attach using acr-resource-id
```
az aks update -n myAKSCluster -g myResourceGroup --attach-acr <acr-resource-id>
```


Reference:
https://github.com/MicrosoftDocs/azure-dev-docs/blob/main/articles/terraform/store-state-in-azure-storage.md
https://github.com/Azure/terraform/blob/master/quickstart/201-aks-acr-identity/main.tf
https://medium.com/ascentic-technology/github-action-deploy-applications-to-aks-7598668f8ee1
