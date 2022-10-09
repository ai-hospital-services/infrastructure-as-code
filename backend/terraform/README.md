# get supported gke versions
```shell
gcloud container get-server-config --flatten="channels" --filter="channels.channel=REGULAR" \
    --format="yaml(channels.channel,channels.defaultVersion)" --region asia-south1
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

```

# destroy terraform
```shell
terraform destroy -var-file="values-secret.tfvars"
```