# create secret vars file
```shell
cp values.tfvars values-secret.tfvars
```

# apply terraform
```shell
terraform apply -var-file="values-secret.tfvars"
```

# get aks credentials for kube context
```shell
az aks get-credentials -n "cloud-hospital-website-aks01" -g "cloud-hospital-website-rg01"
```

# destroy terraform
```shell
terraform destroy -var-file="values-secret.tfvars"
```