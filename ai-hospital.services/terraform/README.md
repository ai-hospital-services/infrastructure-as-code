# get supported aks versions
```shell
az aks get-versions --location centralindia --output table
```

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
az aks get-credentials -n "ai-hospital-web-aks01" -g "ai-hospital-web-rg01"
```

# destroy terraform
```shell
terraform destroy -var-file="values-secret.tfvars"
```